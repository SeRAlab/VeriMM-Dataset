module sha256_simple (
    input wire clk,
    input wire rst,
    input wire [63:0] data_in,
    input wire start,
    output reg [31:0] hash_out,
    output reg done
);

    reg [31:0] hash;
    reg [3:0] state;

    localparam IDLE = 0, PROCESS = 1, DONE = 2;
    localparam INIT_HASH = 32'h6A09E667; // Initial hash value

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hash <= INIT_HASH;
            state <= IDLE;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        hash <= INIT_HASH ^ data_in[31:0]; // Simple round function
                        state <= PROCESS;
                    end
                end
                PROCESS: begin
                    hash <= hash ^ (data_in[63:32] + 32'hBF597FC7); // Another round operation
                    state <= DONE;
                end
                DONE: begin
                    hash_out <= hash;
                    done <= 1;
                    state <= IDLE; // Go back to IDLE
                end
            endcase
        end
    end
endmodule