module top_module(
    input wire clk,
    input wire [255:0] sentence,
    input wire nextWord,
    input wire prevWord,
    output wire [31:0] currentWord,
    output wire [2:0] wordIndex
    );reg [2:0] currentWordIndex = 3'd7;
    
    
    assign currentWord = sentence >> (currentWordIndex * 32);
    
    assign wordIndex = 3'd7 - currentWordIndex;
    
    always @(posedge clk) begin
        
        if (nextWord) currentWordIndex <= currentWordIndex - 1;
        if (prevWord) currentWordIndex <= currentWordIndex + 1;
    end
    
endmodule