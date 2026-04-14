module binary_counter(
    input clk,    // Clock signal.
    input rst,    // Reset signal.
    output reg [2:0] count  // 3-bit Output count.
);

always @(posedge clk or posedge rst) begin
    if (rst) 
        count <= 3'b000;  // Reset count to 0.
    else 
        count <= count + 3'b001;  // Increment count by 1.
end

endmodule