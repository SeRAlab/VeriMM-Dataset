module top_module(
    input CLK,
    input CLR,
    input LD,
    input [3:0] DATA,
    output reg [3:0] Q0,
    output reg [3:0] Q1,
    output reg [3:0] Q2,
    output reg [3:0] Q3
);reg [3:0] pipeline_reg1, pipeline_reg2, pipeline_reg3, pipeline_reg4;

always @(posedge CLK) begin
    if (CLR) begin
        pipeline_reg1 <= 4'b0000;
        pipeline_reg2 <= 4'b0000;
        pipeline_reg3 <= 4'b0000;
        pipeline_reg4 <= 4'b0000;
    end
    else if (LD) begin
        pipeline_reg1 <= DATA;
        pipeline_reg2 <= pipeline_reg1;
        pipeline_reg3 <= pipeline_reg2;
        pipeline_reg4 <= pipeline_reg3;
    end
    else begin
        pipeline_reg1 <= pipeline_reg4 + 4'b0001;
        pipeline_reg2 <= pipeline_reg1;
        pipeline_reg3 <= pipeline_reg2;
        pipeline_reg4 <= pipeline_reg3;
    end
end

assign Q0 = pipeline_reg1;
assign Q1 = pipeline_reg2;
assign Q2 = pipeline_reg3;
assign Q3 = pipeline_reg4;

endmodule