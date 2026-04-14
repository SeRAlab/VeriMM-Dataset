module phase_shifter (
    input [2:0] phase_in,
    input [2:0] shift_amount,
    input clk,
    input rst,
    output reg [2:0] phase_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        phase_out <= 3'b000;
    end else begin
        phase_out <= (phase_in + shift_amount) % 8;
    end
end

endmodule