module top_module(
    input wire CLK,
    input wire [31:0] F,
    input wire RST_FF,
    input wire Begin_FSM_FF,
    output reg ACK_FF, // Changed to reg
    output reg [31:0] RESULT // Changed to reg
);// Extract exponent from input floating-point number
    wire [7:0] exp = F[30:23];
    wire [22:0] mantissa = F[22:0];
    reg [31:0] fixed; // Changed to reg
    reg [4:0] num_bits; // Changed to reg
    reg [31:0] shifted_mantissa; // Changed to reg
    reg [31:0] integer_part; // Changed to reg
    reg [31:0] fractional_part; // Changed to reg
    reg [31:0] final_result; // Changed to reg
    wire [31:0] zero = 32'h00000000;

    // Determine number of bits required to represent integer portion of F
    always @(posedge CLK) begin
        if (RST_FF == 1'b1) begin
            num_bits <= 0; // Reset num_bits on RST_FF
        end else begin
            num_bits <= exp - 127 + 1;
        end
    end
    
    // Convert floating-point number F to fixed-point number
    always @(posedge CLK) begin
        if (RST_FF == 1'b1) begin
            fixed <= zero;
            shifted_mantissa <= zero;
            integer_part <= zero;
            fractional_part <= zero;
        end else if (Begin_FSM_FF == 1'b1) begin
            shifted_mantissa <= {mantissa, 8'h00};
            integer_part <= shifted_mantissa >> (23 - num_bits);
            fractional_part <= shifted_mantissa << (num_bits + 1);
            fixed <= integer_part + (fractional_part >> (num_bits + 1));
        end
    end
    
    // Output resulting fixed-point number and indicate that conversion process is complete
    always @(posedge CLK) begin
        if (RST_FF == 1'b1) begin
            RESULT <= zero;
            ACK_FF <= 1'b0;
        end else if (Begin_FSM_FF == 1'b1) begin
            final_result <= fixed << (31 - num_bits);
            RESULT <= final_result;
            ACK_FF <= 1'b1;
        end else begin
            RESULT <= zero;
            ACK_FF <= 1'b0;
        end
    end

endmodule