module shift_register(
    input clk,
    input reset,
    input [1:0] in,
    output reg [1:0] out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 2'b00;
        end else begin
            out <= {in[0], out[1]}; // Shift right and insert in[0]
        end
    end
endmodule