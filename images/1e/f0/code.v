module state_machine (
    input clk,
    input reset,
    input input_signal,
    output reg state
);

    reg [1:0] count; // counter to track the number of clock cycles in S1

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0; // S0
            count <= 0;
        end else begin
            case (state)
                0: begin // S0
                    if (input_signal) begin
                        state <= 1; // transition to S1
                        count <= 0; // reset count
                    end
                end
                1: begin // S1
                    count <= count + 1; // increment count
                    if (input_signal) begin
                        if (count == 2) begin // three clock cycles in S1
                            state <= 0; // back to S0
                            count <= 0; // reset count
                        end
                    end else begin
                        state <= 0; // transition back to S0
                        count <= 0; // reset count
                    end
                end
            endcase
        end
    end
endmodule