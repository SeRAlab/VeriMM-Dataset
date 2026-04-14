module rrt_state_machine(
    input wire clk,
    input wire reset,
    input wire start,
    input wire reach,
    output reg [1:0] state // 2-bit state representation
);

    localparam IDLE = 2'b00,
               EXPLORE = 2'b01,
               GOAL = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= EXPLORE;
                end
                EXPLORE: begin
                    if (reach) state <= GOAL;
                end
                GOAL: begin
                    state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule