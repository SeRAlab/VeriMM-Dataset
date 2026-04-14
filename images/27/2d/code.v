module PIPO_Shift_Register (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [4:0] data,
    output reg [4:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 5'b00000;
        end else if (load) begin
            q <= data;
        end else begin
            q <= {q[3:0], 1'b0}; // Shift left and fill LSB with 0
        end
    end
endmodule