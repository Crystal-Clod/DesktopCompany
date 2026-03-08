using Godot;
using System;
using System.Runtime.InteropServices;

public partial class HideFromTaskbar : Node2D
{
	
	[DllImport("user32.dll")]
	static extern IntPtr GetActiveWindow();
	[DllImport("User32.dll")]
	public static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);
	[DllImport("User32.dll")]
	public static extern int GetWindowLong(IntPtr hWnd, int nIndex);

	private const int GWL_EXSTYLE = -0x14;
	private const int WS_EX_TOOLWINDOW = 0x0080;
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		var pMainWindow = GetActiveWindow();
		//SetWindowLong(pMainWindow, GWL_EXSTYLE, GetWindowLong(pMainWindow, GWL_EXSTYLE) | WS_EX_TOOLWINDOW);
            
		SetWindowLong(pMainWindow, GWL_EXSTYLE, GetWindowLong(pMainWindow, GWL_EXSTYLE) & ~WS_EX_TOOLWINDOW);
	}
}
