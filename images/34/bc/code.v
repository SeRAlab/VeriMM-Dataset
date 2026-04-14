module huffman_encoder (
    input [7:0] char1, input [7:0] char2, input [7:0] char3, input [7:0] char4, input [7:0] char5,
    input [3:0] freq1, input [3:0] freq2, input [3:0] freq3, input [3:0] freq4, input [3:0] freq5,
    output reg [15:0] code1, output reg [15:0] code2, output reg [15:0] code3, output reg [15:0] code4, output reg [15:0] code5
);

always @(*) begin
    // Example Huffman encoding for characters 'A', 'B', 'C', 'D', 'E' with arbitrary frequencies
    // Assume they are already sorted by frequency: A: 5, B: 9, C: 12, D: 13, E: 16
    code1 = (char1 == "A") ? 16'b00 : 
             (char1 == "B") ? 16'b01 : 
             (char1 == "C") ? 16'b100 :
             (char1 == "D") ? 16'b101 :
             (char1 == "E") ? 16'b11 : 16'b0000;

    code2 = (char2 == "A") ? 16'b00 : 
             (char2 == "B") ? 16'b01 : 
             (char2 == "C") ? 16'b100 :
             (char2 == "D") ? 16'b101 :
             (char2 == "E") ? 16'b11 : 16'b0000;

    code3 = (char3 == "A") ? 16'b00 : 
             (char3 == "B") ? 16'b01 : 
             (char3 == "C") ? 16'b100 :
             (char3 == "D") ? 16'b101 :
             (char3 == "E") ? 16'b11 : 16'b0000;

    code4 = (char4 == "A") ? 16'b00 : 
             (char4 == "B") ? 16'b01 : 
             (char4 == "C") ? 16'b100 :
             (char4 == "D") ? 16'b101 :
             (char4 == "E") ? 16'b11 : 16'b0000;

    code5 = (char5 == "A") ? 16'b00 : 
             (char5 == "B") ? 16'b01 : 
             (char5 == "C") ? 16'b100 :
             (char5 == "D") ? 16'b101 :
             (char5 == "E") ? 16'b11 : 16'b0000;

end

endmodule