module pulse_generator(
    input clk,
    input start,
    input [3:0] width,
    input [3:0] period,
    output reg pulse
);
    reg [3:0] count;
    reg [1:0] state; // 0: idle, 1: generating pulse, 2: waiting for next pulse

    always @(posedge clk) begin
        case(state)
            0: begin
                pulse <= 0;
                count <= 0;
                if (start) begin
                    state <= 1; // Start generating pulse
                end
            end
            1: begin
                pulse <= 1;
                count <= count + 1;
                if (count >= width) begin
                    state <= 2; // Finished generating pulse, wait for period
                    count <= 0;
                end
            end
            2: begin
                pulse <= 0;
                count <= count + 1;
                if (count >= period) begin
                    state <= 0; // Go back to idle state
                end
            end
        endcase
    end
endmodule