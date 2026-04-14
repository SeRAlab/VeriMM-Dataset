module top_module(
    input [8:0] address,
    input clk,
    input debugaccess,
    input monitor_error,
    input monitor_go,
    input monitor_ready,
    input reset_n,
    input write,
    input [31:0] writedata,
    output reg [31:0] oci_ienable,          // Change to reg
    output reg [31:0] oci_reg_readdata,     // Change to reg
    output reg oci_single_step_mode,         // Change to reg
    output reg ocireg_ers,
    output reg ocireg_mrs,
    output take_action_ocireg
);wire oci_reg_00_addressed = (address == 9'h100);
wire oci_reg_01_addressed = (address == 9'h101);

assign take_action_ocireg = (write & debugaccess & oci_reg_00_addressed);

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        oci_single_step_mode <= 1'b0;
    end else if (take_action_ocireg) begin
        oci_single_step_mode <= writedata[3];
    end
end

always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        oci_ienable <= 32'b00000000000000000000000000011111;
    end else if (take_action_ocireg) begin
        oci_ienable <= writedata | ~(32'b00000000000000000000000000011111);
    end
end

assign ocireg_ers = writedata[1];
assign ocireg_mrs = writedata[0];
assign oci_reg_readdata = (oci_reg_00_addressed) ? {28'b0, oci_single_step_mode, monitor_go, monitor_ready, monitor_error} : 
                         (oci_reg_01_addressed) ? oci_ienable : 32'b0;

endmodule