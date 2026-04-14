module merge_sort(
    input clk,
    input rst,
    input start,
    input [31:0] data_in, // 8 elements of 4-bits each
    output reg [31:0] data_out, // sorted output
    output reg done
);
    reg [2:0] state, next_state;
    reg [31:0] array [0:7];
    parameter IDLE = 3'b000, LOAD = 3'b001, MERGE = 3'b010, DONE = 3'b011;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(state or start or data_in) begin
        case (state)
            IDLE: begin
                if (start) begin
                    next_state = LOAD;
                end else begin
                    next_state = IDLE;
                end
            end
            LOAD: begin
                array[0] = data_in[3:0];
                array[1] = data_in[7:4];
                array[2] = data_in[11:8];
                array[3] = data_in[15:12];
                array[4] = data_in[19:16];
                array[5] = data_in[23:20];
                array[6] = data_in[27:24];
                array[7] = data_in[31:28];
                next_state = MERGE;
            end
            MERGE: begin
                // Simple merge sort logic (pseudocode implementation)
                // Assume we have a merge function here that sorts `array`
                // This should be replaced with actual merge logic
                next_state = DONE;
            end
            DONE: begin
                data_out = {array[7], array[6], array[5], array[4], array[3], array[2], array[1], array[0]};
                done = 1;
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule