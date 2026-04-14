module top_module(
    input clk, 
    input [3:0] in, // 4-bit input for the barrel shifter and decoder 
    output reg [15:0] out // 16-bit final output 
);// Barrel Shifter
    reg [3:0] shifted_input;
    assign shifted_input = {in[2:0], 1'b0};
    
    // Decoder
    reg [15:0] decoder_output;
    always @* begin
        case(shifted_input)
            4'b0001: decoder_output = 16'b0000000000000001;
            4'b0010: decoder_output = 16'b0000000000000010;
            4'b0100: decoder_output = 16'b0000000000000100;
            4'b1000: decoder_output = 16'b0000000000001000;
            4'b0011: decoder_output = 16'b0000000000001100;
            4'b0110: decoder_output = 16'b0000000000011000;
            4'b1100: decoder_output = 16'b0000000000110000;
            4'b1111: decoder_output = 16'b0000000001111000;
            default: decoder_output = 16'b0000000000000000;
        endcase
    end
    
    // XOR Module
    reg [15:0] xor_output;
    always @* begin
        xor_output = in ^ shifted_input;
    end
    
    // Multiplexer
    always @* begin
        if (in == 4'b0000) begin
            out = decoder_output;
        end else begin
            out = xor_output;
        end
    end
    
endmodule