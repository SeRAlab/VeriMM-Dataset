module top_module(
  output O,
  input  D, WCLK, WE,
  input  A0, A1, A2, A3, A4
);parameter [31:0] INIT = 32'bx;
    parameter IS_WCLK_INVERTED = 0;

    // Assuming SPRAM32 is supposed to be a pre-defined or another custom module,
    // we define a simple SRAM model for demonstration purposes.
    reg [31:0] memory [31:0]; // 32x1 SRAM
    reg [31:0] O_reg;
    
    always @(posedge WCLK) begin
        if (WE) begin
            memory[{A4, A3, A2, A1, A0}] <= D; // Write operation
        end
        O_reg <= memory[{A4, A3, A2, A1, A0}]; // Read operation
    end

    assign O = O_reg; // Assign the output

endmodule