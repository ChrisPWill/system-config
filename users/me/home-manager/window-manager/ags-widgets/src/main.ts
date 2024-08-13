const hyprland = await Service.import("hyprland");

const Workspaces = (monitor: number) => {
  const activeIdsBinding = hyprland.bind("monitors").as((monitors) =>
    monitors.reduce<Set<number>>((activeSet, monitor) => {
      activeSet.add(monitor.activeWorkspace.id);
      return activeSet;
    }, new Set()),
  );
  const workspaces = hyprland.bind("workspaces").as((workspaces) =>
    workspaces
      // Only get workspaces on the monitor that has this bar
      .filter(({ monitorID }) => monitor === monitorID)
      // Sort by id
      .sort(({ id: id1 }, { id: id2 }) => (id1 > id2 ? 1 : id2 > id1 ? -1 : 0))
      // Create a button per workspace
      .map(({ id: workspaceId, windows: workspaceWindows }) => {
        const className = activeIdsBinding.as((activeIdSet) =>
          [
            "workspace",
            activeIdSet.has(workspaceId) ? "active" : undefined,
            workspaceWindows > 0 ? "has_window" : undefined,
          ]
            .filter((className) => className !== undefined)
            .join(" "),
        );

        const workspaceLabel = Widget.Label({
          class_name: className,
          label: workspaceWindows > 0 ? `${workspaceId}` : `${workspaceId}`,
        });
        return workspaceLabel;
      }),
  );

  return Widget.Box({
    class_name: "workspaces",
    children: workspaces,
  });
};

const ClientTitle = (monitorId: number) => {
  // TODO: Use Utils.merge as per
  // https://aylur.github.io/ags-docs/config/services/ 
  return Widget.Label({
    setup: (self) =>
      self.hook(hyprland.active.client, (self) => {
        const activeWorkspaceId =
          hyprland.getMonitor(monitorId)?.activeWorkspace.id;
        const activeClient = hyprland.clients
          .filter((client) => client.workspace.id === activeWorkspaceId)
          .sort((c1, c2) =>
            c1.focusHistoryID > c2.focusHistoryID
              ? 1
              : c1.focusHistoryID < c2.focusHistoryID
                ? -1
                : 0,
          )[0];
        const title = activeClient.title ?? "";
        self.class_name = title.length > 0 ? "client-title" : "";
        self.label = title;
      }),
  });
};

const Left = (monitor: number) => {
  return Widget.Box({
    spacing: 8,
    children: [Workspaces(monitor), ClientTitle(monitor)],
  });
};

const Bar = (monitor: number) =>
  Widget.Window({
    name: `bar-${monitor}`,
    class_name: "bar",
    monitor,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      start_widget: Left(monitor),
    }),
  });

App.config({
  windows: () => hyprland.monitors.map((monitor) => monitor.id).map(Bar),
  style: "/tmp/ags/js/style.css",
});

export {};
