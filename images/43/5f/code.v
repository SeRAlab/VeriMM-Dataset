module top_module(
    input clk,
    input reset,
    input [1:0] decoder_out,
    input [15:0] data_a,
    input [15:0] data_b,
    output reg [31:0] product
);// Implementing the 2-to-4 decoder using a NAND gate
    wire nand_out;
    assign nand_out = ~(decoder_out[0] & decoder_out[1]);
    
    // Logic to select between multiplier and 0 output
    reg [31:0] output_select;
    always @ (posedge clk, posedge reset) begin
        if (reset) begin
            output_select <= 0;
        end else begin
            case (decoder_out)
                2'b00: output_select <= 0;
                2'b01: output_select <= 0;
                2'b10: output_select <= data_a * data_b;
                2'b11: output_select <= data_a * data_b;
            endcase
        end
    end
    
    // Assigning the output based on the decoder output and the output select logic
    always @ (posedge clk) begin
        if (nand_out) begin
            product <= output_select;
        end else begin
            product <= 0;
        end
    end
    
endmodule