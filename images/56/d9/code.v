module shift_reg_4bit (
    input wire clk,
    input wire reset,
    input wire load,
    input wire shift,
    input wire [3:0] data_in,
    output reg [3:0] q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else if (load) begin
            q <= data_in;
        end else if (shift) begin
            q <= {q[2:0], 1'b0}; // Shift left
        end
    end
endmodule