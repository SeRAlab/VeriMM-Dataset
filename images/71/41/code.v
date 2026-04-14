module top_module(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor,
    output reg [1:0] pos,
    output reg [7:0] final_output // Change to reg
);// AND gate
    assign out_and = in[0] & in[1] & in[2] & in[3];
    
    // OR gate
    assign out_or = in[0] | in[1] | in[2] | in[3];
    
    // XOR gate
    assign out_xor = in[0] ^ in[1] ^ in[2] ^ in[3];
    
    // MUX for position of highest bit
    always @* begin
        if (in[3] == 1) pos = 2'b11;
        else if (in[2] == 1) pos = 2'b10;
        else if (in[1] == 1) pos = 2'b01;
        else if (in[0] == 1) pos = 2'b00;
        else pos = 2'b00;
    end
    
    // Functional module for sum of outputs
    always @* begin
        case ({out_and, out_or, out_xor})
            3'b000: final_output = 8'b00000000;
            3'b001: final_output = 8'b00000001;
            3'b010: final_output = 8'b00000010;
            3'b011: final_output = 8'b00000011;
            3'b100: final_output = 8'b00000100;
            3'b101: final_output = 8'b00000101;
            3'b110: final_output = 8'b00000110;
            3'b111: final_output = 8'b00000111;
            default: final_output = 8'b00000000; // Default case for safety
        endcase
    end
    
endmodule