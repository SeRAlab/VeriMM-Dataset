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
    output reg [31:0] oci_ienable,
    output reg [31:0] oci_reg_readdata,
    output reg oci_single_step_mode,
    output reg ocireg_ers,
    output reg ocireg_mrs,
    output reg take_action_ocireg
);wire oci_reg_00_addressed = (address == 9'h100);
    wire oci_reg_01_addressed = (address == 9'h101);
    wire write_strobe = write & debugaccess;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            oci_single_step_mode <= 1'b0;
        end else if (write_strobe && oci_reg_00_addressed) begin
            oci_single_step_mode <= writedata[3];
            ocireg_ers <= writedata[1];
            ocireg_mrs <= writedata[0];
            take_action_ocireg <= 1'b1;
        end else begin
            take_action_ocireg <= 1'b0;
        end
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            oci_ienable <= 32'h00000001;
        end else if (write_strobe && oci_reg_01_addressed) begin
            oci_ienable <= writedata | ~32'h00000001;
        end
    end

    always @(*) begin
        if (oci_reg_00_addressed) begin
            oci_reg_readdata[31:5] = 27'b0;
            oci_reg_readdata[4] = oci_single_step_mode;
            oci_reg_readdata[3] = monitor_go;
            oci_reg_readdata[2] = monitor_ready;
            oci_reg_readdata[1] = monitor_error;
        end else if (oci_reg_01_addressed) begin
            oci_reg_readdata = oci_ienable;
        end else begin
            oci_reg_readdata = 32'b0;
        end
    end

endmodule