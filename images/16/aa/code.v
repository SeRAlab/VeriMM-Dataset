module crystal_oscillator (
    input clk,
    input reset,
    input [1:0] freq_sel,
    output reg out
);
    reg [1:0] counter; // 2-bit counter for frequency division
    reg [1:0] div_value; // Divider value based on frequency selection

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            out <= 0;
        end else begin
            // Set divider value based on selected frequency
            case (freq_sel)
                2'b00: div_value <= 2; // 1/2 frequency
                2'b01: div_value <= 4; // 1/4 frequency
                2'b10: div_value <= 8; // 1/8 frequency
                2'b11: div_value <= 16; // 1/16 frequency
                default: div_value <= 2; // Default to 1/2
            endcase
            
            if (counter < div_value - 1) begin
                counter <= counter + 1;
            end else begin
                counter <= 0;
                out <= ~out; // Toggle output
            end
        end
    end
endmodule