module simple_fsm (
    input clk,
    input rst,
    input [4:0] inp,
    output reg out
);
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00; // reset to state 0
            out <= 0;
        end else begin
            case (state)
                2'b00: if (inp[0]) state <= 2'b01; // State 0
                2'b01: if (inp[0] == 0) state <= 2'b10; // State 1
                2'b10: if (inp[0]) state <= 2'b11; else state <= 2'b00; // State 2
                2'b11: if (inp[0] == 0) state <= 2'b01; // State 3
            endcase
            out <= (state == 2'b10) ? 1 : 0; // Output 1 when in State 2
        end
    end
endmodule