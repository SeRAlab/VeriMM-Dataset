module top_module(
    input [3:0] binary,
    output reg [7:0] twos_complement  // Change the output to reg to allow assignment in always block
);reg [3:0] inverted_binary;
reg [3:0] one = 1;

always @(*) begin
    inverted_binary = ~binary + one; // Add 1 in an appropriate manner (replace with 'one')
    
    if (binary[3] == 1) begin
        twos_complement = {4'b1111, inverted_binary};  // Concatenate inverted and 4'b1111
    end else begin
        twos_complement = {4'b0000, binary};  // Concatenate the binary number with leading zeros
    end
end

endmodule