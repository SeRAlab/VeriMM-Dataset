module top_module(
    input CLK,
    input SI,
    output SO,
    output reg [3:0] Q
);reg [3:0] pipeline_reg;

always @(posedge CLK) begin
    if (SI) begin
        pipeline_reg <= 1'b1;
    end else begin
        pipeline_reg <= {pipeline_reg[2:0], SO};
    end
end

assign SO = pipeline_reg[0];
assign Q = pipeline_reg;

endmodule