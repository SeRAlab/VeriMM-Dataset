module top_module(
    input wire clk,
    input wire reset,
    input wire s_axis_ireq_tvalid,
    input wire [63:0] s_axis_ireq_tdata,
    output reg m_axis_iresp_tvalid,
    output reg [63:0] m_axis_iresp_tdata
);reg [31:0] reg1;
reg [15:0] reg2;
reg [15:0] reg3;
reg [47:0] reg4;
reg [63:0] reg5;

always @(posedge clk) begin
    if (reset) begin
        reg1 <= 0;
        reg2 <= 0;
        reg3 <= 0;
        reg4 <= 0;
        reg5 <= 0;
        m_axis_iresp_tvalid <= 0;
        m_axis_iresp_tdata <= 0;
    end else begin
        if (s_axis_ireq_tvalid) begin
            reg1 <= s_axis_ireq_tdata[31:0];
            reg2 <= s_axis_ireq_tdata[47:32];
            reg3 <= s_axis_ireq_tdata[63:48];
            reg4 <= reg1 * reg2;
            reg5 <= reg4 + reg3;
            m_axis_iresp_tvalid <= 1;
            m_axis_iresp_tdata <= reg5;
        end else begin
            m_axis_iresp_tvalid <= 0;
            m_axis_iresp_tdata <= 0;
        end
    end
end

endmodule