module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [1:0] channel_select,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg done
);
    reg state; // 0: idle, 1: transferring
    reg [1:0] current_channel;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            data_out <= 8'b0;
            done <= 0;
        end else begin
            case (state)
                0: begin // idle state
                    done <= 0;
                    if (start) begin
                        current_channel <= channel_select;
                        state <= 1; // go to transferring state
                    end
                end
                1: begin // transferring state
                    data_out <= data_in; // transfer data
                    done <= 1; // signal done
                    state <= 0; // return to idle
                end
            endcase
        end
    end
endmodule