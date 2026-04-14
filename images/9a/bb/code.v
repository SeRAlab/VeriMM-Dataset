module top_module(
    input EN,
    output reg Q0,
    output reg Q1,
    output reg Q2,
    output reg Q3
);reg [3:0] pipeline_reg1;
reg [3:0] pipeline_reg2;
reg [3:0] pipeline_reg3;

always @(posedge EN) begin
    if (EN == 1'b1) begin
        pipeline_reg1 <= 4'b0000;
        pipeline_reg2 <= 4'b0000;
        pipeline_reg3 <= 4'b0000;
    end else begin
        pipeline_reg1 <= pipeline_reg2;
        pipeline_reg2 <= pipeline_reg3;
        pipeline_reg3 <= pipeline_reg3 + 1;
    end
end

assign Q0 = pipeline_reg1[0] ^ pipeline_reg2[0];
assign Q1 = pipeline_reg1[1] ^ pipeline_reg2[1];
assign Q2 = pipeline_reg1[2] ^ pipeline_reg2[2];
assign Q3 = pipeline_reg1[3] ^ pipeline_reg2[3];

endmodule