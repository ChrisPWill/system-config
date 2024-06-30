const Bar = (monitor: number) =>
  Widget.Window({
    name: `bar-${monitor}`,
    child: Widget.Label("hello 2"),
    anchor: ["top", "left", "right"],
  });

App.config({
  windows: [Bar(0)],
});
