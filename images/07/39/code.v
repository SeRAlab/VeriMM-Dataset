module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire start,
    output reg done
);
    parameter CYCLE_COUNT = 5;
    reg [2:0] state;
    reg [2:0] counter;

    localparam IDLE = 3'b000,
               BUSY = 3'b001,
               DONE = 3'b010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counter <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= BUSY;
                        counter <= 0;
                        done <= 0;
                    end
                end
                BUSY: begin
                    if (counter < CYCLE_COUNT - 1) begin
                        counter <= counter + 1;
                    end else begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    done <= 1;
                    state <= IDLE; // Transition back to IDLE after done
                end
            endcase
        end
    end
endmodule