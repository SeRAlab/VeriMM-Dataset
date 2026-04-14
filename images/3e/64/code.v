module dma_controller(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] src_addr,
    input wire [7:0] dest_addr,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg done
);
    reg [1:0] state; // 0: idle, 1: read, 2: write
    reg [7:0] internal_data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            done <= 0;
        end else begin
            case (state)
                0: begin // idle
                    done <= 0;
                    if (start) begin
                        state <= 1; // go to read state
                    end
                end
                1: begin // read
                    internal_data <= data_in; // simulate reading from source
                    state <= 2; // go to write state
                end
                2: begin // write
                    data_out <= internal_data; // simulate writing to destination
                    done <= 1; // signal done
                    state <= 0; // back to idle
                end
            endcase
        end
    end
endmodule