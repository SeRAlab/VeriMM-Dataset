module top_module(
    input wire CLK,
    input wire RESET,
    input wire CE,
    output reg CLOCK  // Changed from wire to reg
);parameter DIVISOR = 8;
    reg [DIVISOR-1:0] counter;
    
    always @(posedge CLK or negedge RESET) begin
        if (!RESET) begin
            counter <= 0;
            CLOCK <= 0;
        end else if (CE) begin
            counter <= counter + 1;
            if (counter == DIVISOR-1) begin
                counter <= 0;
                CLOCK <= ~CLOCK;
            end
        end
    end

endmodule