module top_module(
    input  D      ,
    output reg Q  ,  // Changed from 'output' to 'output reg'
    input  RESET_B,
    input  SCD    ,
    input  SCE    ,
    input  CLK    ,
    input  SLEEP_B,
    input  KAPWR  ,
    input  VPB    ,
    input  VPWR   ,
    input  VGND   ,
    input  VNB
);reg [1:0] scan_chain;
    reg [1:0] shift_register;

    always @(posedge CLK) begin
        if (SCE == 1'b1) begin
            scan_chain[0] <= D;
            scan_chain[1] <= RESET_B;
        end
        shift_register <= scan_chain;
    end

    always @(posedge CLK) begin
        if (RESET_B == 1'b0) begin
            Q <= 1'b0;
        end
        else begin
            Q <= shift_register[0];
        end
    end

endmodule