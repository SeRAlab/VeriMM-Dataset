module md5_hash (
    input clk,
    input reset,
    input start,
    input [511:0] message,
    output reg [127:0] hash,
    output reg ready
);

    // Internal states
    reg [63:0] A, B, C, D;
    reg [511:0] data_block;
    reg [3:0] state; // 0: idle, 1: process, 2: done

    initial begin
        A = 64'h67452301;
        B = 64'hEFCDAB89;
        C = 64'h98BADCFE;
        D = 64'h10325476;
        hash = 128'b0;
        ready = 0;
        state = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 64'h67452301;
            B <= 64'hEFCDAB89;
            C <= 64'h98BADCFE;
            D <= 64'h10325476;
            hash <= 128'b0;
            ready <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // idle
                    if (start) begin
                        data_block <= message;
                        state <= 1;
                    end
                end
                1: begin // process
                    // Simplified MD5 processing (not complete, for the sake of the problem)
                    // Assume a single round of processing here
                    A <= A + (B ^ C ^ D) + data_block[31:0]; // Some operation
                    B <= B + A;
                    C <= C + B;
                    D <= D + C;
                    state <= 2;
                end
                2: begin // done
                    hash <= {A[31:0], B[31:0], C[31:0], D[31:0]};
                    ready <= 1;
                    state <= 0;
                end
            endcase
        end
    end
endmodule