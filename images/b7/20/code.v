module top_module( 
    input wire clk,            // Added clk input
    input wire [15:0] in,
    output reg [7:0] out_hi,  // Changed output to reg type
    output reg [7:0] out_lo );// Changed output to reg type

    // Pipeline registers
    reg [15:0] in_reg;
    reg [7:0] out_hi_reg;
    reg [7:0] out_lo_reg;

    // Barrel shifter
    reg [15:0] shifted_in;
    always @(*) begin
        shifted_in = in_reg >> 8;
    end

    // Multiplexer
    always @(*) begin
        if (in_reg[7:0] == 0) begin
            out_hi_reg = shifted_in[15:8];
        end else begin
            out_hi_reg = in_reg[15:8];
        end
        out_lo_reg = in_reg[7:0];
    end

    // Pipeline stages
    always @(posedge clk) begin
        in_reg <= in;
        out_hi <= out_hi_reg;
        out_lo <= out_lo_reg;
    end

endmodule