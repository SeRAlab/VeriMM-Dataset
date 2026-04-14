module shift_register (
    input clk,
    input rst,
    input [3:0] data,
    input load,
    input shift,
    output reg [3:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 4'b0000;  // Reset the shift register
    end else if (load) begin
        q <= data;     // Load the input data
    end else if (shift) begin
        q <= {1'b0, q[3:1]};  // Shift right and fill with 0
    end
end

endmodule