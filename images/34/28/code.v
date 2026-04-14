module chebyshev_filter (
    input wire clk,
    input wire rst,
    input wire [3:0] x_in, // 4-bit input signal
    output reg [3:0] y_out // 4-bit output signal
);
    reg [3:0] state; // internal state

    // State definitions
    localparam STATE_0 = 4'b0000;
    localparam STATE_1 = 4'b0001;
    localparam STATE_2 = 4'b0010;

    // State transition and output logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= STATE_0;
            y_out <= 4'b0000;
        end else begin
            case (state)
                STATE_0: begin
                    y_out <= x_in; // Directly pass input in STATE_0
                    state <= STATE_1;
                end
                STATE_1: begin
                    y_out <= (x_in + y_out) >> 1; // Simple averaging in STATE_1
                    state <= STATE_2;
                end
                STATE_2: begin
                    y_out <= (2 * y_out) - x_in; // Feedback mechanism in STATE_2
                    state <= STATE_0;
                end
                default: begin
                    state <= STATE_0;
                end
            endcase
        end
    end
endmodule