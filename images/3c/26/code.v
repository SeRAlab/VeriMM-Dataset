module ecc_point_doubling (
    input clk,
    input reset,
    input start,
    input [31:0] x_in,
    input [31:0] y_in,
    output reg [31:0] x_out,
    output reg [31:0] y_out,
    output reg done
);
    parameter p = 32'hFFFFFFFF; // example prime number
    reg [31:0] x_squared;
    reg [31:0] y_squared;
    reg [31:0] two_xy;
    reg [2:0] state;

    localparam IDLE = 3'b000,
               CALC_X = 3'b001,
               CALC_Y = 3'b010,
               OUTPUT = 3'b011;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            x_out <= 0;
            y_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        x_squared <= (x_in * x_in) % p;
                        y_squared <= (y_in * y_in) % p;
                        state <= CALC_X;
                    end
                end
                CALC_X: begin
                    x_out <= (x_squared - y_squared) % p;
                    state <= CALC_Y;
                end
                CALC_Y: begin
                    two_xy <= (2 * x_in * y_in) % p;
                    y_out <= two_xy;
                    state <= OUTPUT;
                end
                OUTPUT: begin
                    done <= 1;
                    state <= IDLE; // Reset for next operation
                end
            endcase
        end
    end
endmodule