module top_module( 
    input [63:0] in,
    input [3:0] sel,
    input clk,            // Added clk as input
    output reg out       // Change out to reg as it is assigned in an always block
);reg [3:0] sel_reg;
    reg [3:0] in_reg [3:0];
    reg [3:0] comp_val;
    reg [3:0] mux_out_reg;
    reg [3:0] mux_out_next;  // Change mux_out_next to reg

    // Pipeline registers
    always @(posedge clk) begin
        sel_reg <= sel;
        in_reg[0] <= in[3:0];
        in_reg[1] <= in[7:4];
        in_reg[2] <= in[11:8];
        in_reg[3] <= in[15:12];
        comp_val <= 4'hF; // Fixed 4-bit value to compare with
    end

    // Multiplexer
    always @(posedge clk) begin
        case(sel_reg)
            4'b0000: mux_out_next <= in_reg[0];
            4'b0001: mux_out_next <= in_reg[1];
            4'b0010: mux_out_next <= in_reg[2];
            4'b0011: mux_out_next <= in_reg[3];
            default: mux_out_next <= 4'b0000; // Add default case to prevent latches
        endcase
    end

    // Pipeline registers for mux output
    always @(posedge clk) begin
        mux_out_reg <= mux_out_next;
    end

    // Comparator
    always @(posedge clk) begin
        if(mux_out_reg == comp_val)
            out <= 1'b1;
        else
            out <= 1'b0;
    end

endmodule