module shift_register (
    input wire clk,
    input wire reset,
    input wire shift_in,
    output reg [7:0] shift_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_out <= 8'b00000000;
        end else begin
            shift_out <= {shift_in, shift_out[7:1]};
        end
    end
endmodule