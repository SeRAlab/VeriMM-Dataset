module pll_8x (
    input wire clk_in,       // Input clock signal
    input wire reset,        // Reset signal
    output wire clk_out      // Output clock signal
);
    reg [2:0] state;         // State variable for the PLL
    reg clk_out_reg;         // Register for output clock signal

    // State encoding
    localparam IDLE = 3'b000, 
               LOCKED = 3'b001;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            clk_out_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    // Simulating locking process
                    state <= LOCKED;
                end
                LOCKED: begin
                    // Generate output clock at 8x frequency
                    clk_out_reg <= ~clk_out_reg;
                end
            endcase
        end
    end

    assign clk_out = clk_out_reg;

endmodule