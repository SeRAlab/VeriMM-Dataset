module top_module(monitorOrMissedSceneIn, demoOrRealModeIn, resetSetLoadStartIn, toggleSwitches17To14In, toggleSwitches13To10In, clkIn, monitorOrMissedSceneOut, demoOrRealModeOut, resetSetLoadStartOut, toggleSwitches17To14Out, toggleSwitches13To10Out, clkOut);input clkIn, demoOrRealModeIn, monitorOrMissedSceneIn;
input [3:0] toggleSwitches17To14In, resetSetLoadStartIn; 
input [3:0] toggleSwitches13To10In;
output clkOut, demoOrRealModeOut, monitorOrMissedSceneOut;
output [3:0] toggleSwitches17To14Out, resetSetLoadStartOut; 
output [3:0] toggleSwitches13To10Out;

assign clkOut = clkIn;
assign demoOrRealModeOut = demoOrRealModeIn;
assign monitorOrMissedSceneOut = monitorOrMissedSceneIn;
assign toggleSwitches17To14Out = toggleSwitches17To14In; 
assign resetSetLoadStartOut = resetSetLoadStartIn;
assign toggleSwitches13To10Out = toggleSwitches13To10In;

endmodule