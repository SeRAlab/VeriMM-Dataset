module DVFS_Controller(
    input wire clk,
    input wire reset,
    input wire [7:0] temperature, // 8-bit temperature input
    output reg [1:0] state, // 2-bit state output
    output reg [1:0] voltage, // 2-bit voltage level
    output reg [1:0] frequency // 2-bit frequency level
);
    // State encoding
    localparam HIGH = 2'b00;
    localparam MEDIUM = 2'b01;
    localparam LOW = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= MEDIUM; // Default state
            voltage <= 2'b10; // Default high voltage
            frequency <= 2'b10; // Default high frequency
        end else begin
            case (state)
                HIGH: begin
                    if (temperature > 75) begin
                        state <= MEDIUM;
                        voltage <= 2'b01; // Lower voltage
                        frequency <= 2'b01; // Lower frequency
                    end
                end
                MEDIUM: begin
                    if (temperature > 75) begin
                        state <= LOW;
                        voltage <= 2'b00; // Lowest voltage
                        frequency <= 2'b00; // Lowest frequency
                    end else if (temperature < 50) begin
                        state <= HIGH;
                        voltage <= 2'b10; // High voltage
                        frequency <= 2'b10; // High frequency
                    end
                end
                LOW: begin
                    if (temperature < 50) begin
                        state <= MEDIUM;
                        voltage <= 2'b01; // Medium voltage
                        frequency <= 2'b01; // Medium frequency
                    end
                end
            endcase
        end
    end
endmodule