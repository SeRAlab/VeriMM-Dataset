module state_machine (
    input clk,
    input reset,
    input start,
    output reg [2:0] count,
    output reg [1:0] state
);
    
    parameter IDLE = 2'b00, COUNT = 2'b01, RESET = 2'b10;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count <= 3'b000;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= COUNT;
                    end
                end
                COUNT: begin
                    if (count < 3'b101) begin
                        count <= count + 1;
                    end else begin
                        state <= RESET;
                    end
                end
                RESET: begin
                    count <= 3'b000;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule