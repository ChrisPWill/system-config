const hyprland = await Service.import("hyprland");
// Hard-coded until I come up with a better method
const MAIN_MONITOR = 1;

const Workspaces = (monitor: number) => {
  const activeId = hyprland.active.workspace.bind("id");
  const workspaces = hyprland.bind("workspaces").as((workspaces) =>
    workspaces
      // Only get workspaces on the monitor that has this bar
      .filter(({ monitorID }) => monitor === monitorID)
      // Sort by id
      .sort(({ id: id1 }, { id: id2 }) => (id1 > id2 ? 1 : id2 > id1 ? -1 : 0))
      // Create a button per workspace
      .map(({ id }) =>
        Widget.Button({
          on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
          child: Widget.Label(`${id}`),
          class_name: activeId.as((i) => `${i === id ? "focused" : ""}`),
        }),
      ),
  );

  return Widget.Box({
    class_name: "workspaces",
    children: workspaces,
  });
};

const ClientTitle = (monitor: number) => {
  return Widget.Label({
    class_name: "client-title",
    label: hyprland.active.client
      .bind("title")
      .as((title) => (monitor === MAIN_MONITOR ? title : "")),
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
  // style: "/tmp/ags/js/style.css",
});

export {};
