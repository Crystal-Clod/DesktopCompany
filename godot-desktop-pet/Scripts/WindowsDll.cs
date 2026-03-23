using Godot;
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

public partial class WindowsDll : Node
{
	[DllImport("user32.dll")]
	private static extern IntPtr GetForegroundWindow();

	[DllImport("user32.dll")]
	private static extern IntPtr GetActiveWindow();

	[DllImport("user32.dll", SetLastError = true)]
	static extern uint GetWindowThreadProcessId(IntPtr _hWnd, out uint _lpdwProcessId);
	
	public string CurrentWindowInFocus;
	public string MostRecentNonGameWindowInFocus;
	public string PreviousWindowInFocus;
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		var _windowInFront = GetWindowInFront();
		CurrentWindowInFocus = _windowInFront;
		/*if (CurrentWindowInFocus != Application.productName)
		{
			MostRecentNonGameWindowInFocus = _windowInFront;
		}*/
		
		

		if (CurrentWindowInFocus == PreviousWindowInFocus) return;
			
			
		PreviousWindowInFocus = _windowInFront;
		GD.Print(CurrentWindowInFocus);
		
	}
	
	private string GetWindowInFront()
		{
			var _processes = Process.GetProcesses();
			GetWindowThreadProcessId(GetForegroundWindow(), out var _processID);

			foreach (var _process in _processes)
			{
				if (_process.Id == _processID)
				{
					//GameEvents.OnBuildDebugTest(process.ProcessName + " is in focus");
					return _process.ProcessName;
				}
			}

			return null;
		}
		
		public string GetWindowThatIsActive()
		{
			var _processes = Process.GetProcesses();
			GetWindowThreadProcessId(GetActiveWindow(), out var _processID);

			foreach (var _process in _processes)
			{
				if (_process.Id == _processID)
				{
					//GameEvents.OnBuildDebugTest(process.ProcessName + " is in focus");
					return _process.ProcessName;
				}
			}

			return null;
		}
}
