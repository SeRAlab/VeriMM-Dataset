module top_module(
    input CLK,
    input RESET_N,
    input LOAD,
    input [7:0] DATA_IN,
    output reg Q
);reg [7:0] shift_reg;

always @ (posedge CLK, negedge RESET_N) begin
    if (~RESET_N) begin
        shift_reg <= 8'b0;
    end else if (LOAD) begin
        shift_reg <= DATA_IN;
    end else begin
        shift_reg <= {shift_reg[6:0], shift_reg[7]};
    end
end

assign Q = shift_reg[0];

endmodule