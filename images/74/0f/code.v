module top_module(
    input clk,              // Added clk input here
    input [1:0] counter_input,
    input [1:0] decoder_input,
    output reg [15:0] decoder_output,
    output reg final_output
);// 4-to-16 Decoder using NAND gates
    wire [15:0] nand_output;
    assign nand_output = ~{decoder_input[1], decoder_input[0], decoder_input[1], ~decoder_input[0]} & 
                         ~{decoder_input[1], ~decoder_input[0], decoder_input[1], decoder_input[0]} &
                         ~{~decoder_input[1], decoder_input[0], ~decoder_input[1], ~decoder_input[0]} &
                         ~{~decoder_input[1], ~decoder_input[0], ~decoder_input[1], decoder_input[0]};
    
    // 2-bit Binary Counter
    reg [1:0] counter;
    always @(posedge clk) begin
        if (counter == 2'b11) begin
            counter <= 2'b00;
        end else begin
            counter <= counter + 1;
        end
    end
    
    // Final Output
    always @(nand_output or counter) begin
        decoder_output <= nand_output;
        final_output <= nand_output[counter];
    end

endmodule