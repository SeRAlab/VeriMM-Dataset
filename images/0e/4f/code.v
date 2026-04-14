module PLL_4x (
    input wire clk_in,
    input wire reset,
    output wire clk_out
);
    reg [1:0] state;
    reg clk_out_reg;
    
    // State encoding
    localparam IDLE = 2'b00, 
               MULTIPLY = 2'b01,
               OUTPUT = 2'b10;
    
    // Clock divider for 4 times the input clock
    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            clk_out_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    clk_out_reg <= 0;
                    state <= MULTIPLY;
                end
                MULTIPLY: begin
                    clk_out_reg <= ~clk_out_reg; // Toggle the output clock
                    if (clk_out_reg) begin
                        state <= OUTPUT; // Go to OUTPUT state when toggled
                    end
                end
                OUTPUT: begin
                    if (clk_out_reg) begin
                        state <= IDLE; // Reset to IDLE after output
                    end
                end
            endcase
        end
    end

    assign clk_out = clk_out_reg;

endmodule