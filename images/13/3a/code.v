module dvfs_controller(
    input clk,
    input reset,
    input [1:0] voltage_level, // 00: 1.0V, 01: 0.9V, 10: 0.8V
    output reg freq_out
);

reg [31:0] counter;
reg [31:0] freq_div;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        freq_out <= 1; // Default to high frequency
        freq_div <= 5; // Default divisor for 200MHz
    end else begin
        case (voltage_level)
            2'b00: freq_div <= 5;   // 200MHz
            2'b01: freq_div <= 6;   // 150MHz
            2'b10: freq_div <= 10;  // 100MHz
            default: freq_div <= 5; // Default to 200MHz
        endcase
        
        counter <= counter + 1;
        if (counter >= freq_div) begin
            freq_out <= ~freq_out; // Toggle frequency output
            counter <= 0;
        end
    end
end

endmodule