module shift_register (
    input clk,
    input reset,
    input load,
    input [3:0] data_in,
    output reg [3:0] data_out
);

reg [3:0] shift_reg;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 4'b0;
    end else if (load) begin
        shift_reg <= data_in;
    end else begin
        shift_reg <= {shift_reg[2:0], data_in};
    end
end

assign data_out = shift_reg;

endmodule