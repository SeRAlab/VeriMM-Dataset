module top_module(
    input clk,
    input load,
    input data_in,
    input shift_in,
    input reset,
    output reg [7:0] data_out
);reg [7:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 8'b0;
    end else if (load) begin
        shift_reg <= data_in;
    end else begin
        shift_reg <= {shift_reg[6:0], shift_in};
    end
end

assign data_out = shift_reg;

endmodule