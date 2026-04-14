module dma_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [1:0] channel_select,
    input wire [31:0] source_address,
    input wire [31:0] dest_address,
    input wire [31:0] data_in,
    output reg [31:0] data_out,
    output reg done
);
    reg [1:0] state;
    reg [31:0] channel_sources [0:3];
    reg [31:0] channel_dests [0:3];
    reg [31:0] channel_data [0:3];
    reg [1:0] current_channel;

    localparam IDLE = 2'b00;
    localparam READ = 2'b01;
    localparam WRITE = 2'b10;
    localparam DONE = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            current_channel <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        current_channel <= channel_select;
                        channel_sources[current_channel] <= source_address;
                        channel_dests[current_channel] <= dest_address;
                        state <= READ;
                        done <= 0;
                    end
                end

                READ: begin
                    data_out <= data_in; // Simulating read from source
                    state <= WRITE;
                end

                WRITE: begin
                    channel_data[current_channel] <= data_out; // Simulating write to destination
                    state <= DONE;
                end

                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule