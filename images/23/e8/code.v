module pll_2x (
    input wire clk_in,
    input wire enable,
    input wire [1:0] control_word,
    output reg clk_out
);
    reg [1:0] state;
    
    always @(posedge clk_in) begin
        if (enable) begin
            case (control_word)
                2'b00: state <= 2'b00; // No multiplication
                2'b01: state <= 2'b01; // 2x
                2'b10: state <= 2'b10; // 4x
                2'b11: state <= 2'b11; // 8x
                default: state <= 2'b00;
            endcase
        end
    end

    always @(posedge clk_in) begin
        if (enable) begin
            case (state)
                2'b00: clk_out <= 0; // No output
                2'b01: clk_out <= ~clk_out; // 2x output
                2'b10: clk_out <= clk_out; // Placeholder for 4x output logic
                2'b11: clk_out <= clk_out; // Placeholder for 8x output logic
                default: clk_out <= 0;
            endcase
        end
        else begin
            clk_out <= 0; // Disable output
        end
    end
endmodule