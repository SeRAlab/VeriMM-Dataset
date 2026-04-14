module top_module(CLK, RST_N, D_IN, ENQ, DEQ, CLR, D_OUT, EMPTY_N, FULL_N);parameter DATA_WIDTH = 153;
    parameter ADDR_WIDTH = 8;
    parameter DEPTH = 2**ADDR_WIDTH;

    input CLK;
    input RST_N;
    input [DATA_WIDTH-1:0] D_IN;
    input ENQ;
    input DEQ;
    input CLR;
    output reg [DATA_WIDTH-1:0] D_OUT;
    output EMPTY_N;
    output FULL_N;

    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [DATA_WIDTH-1:0] data_out;
    reg [DATA_WIDTH-1:0] data_in;

    assign EMPTY_N = (wr_ptr != rd_ptr);
    assign FULL_N = ((wr_ptr + 1) % DEPTH) == rd_ptr;

    always @(posedge CLK or negedge RST_N) begin
        if (!RST_N) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
        end else begin
            if (CLR) begin
                wr_ptr <= 0;
                rd_ptr <= 0;
            end else begin
                // Write logic
                if (ENQ && !FULL_N) begin
                    mem[wr_ptr] <= D_IN;
                    wr_ptr <= (wr_ptr + 1) % DEPTH;
                end
                // Read logic
                if (DEQ && !EMPTY_N) begin
                    D_OUT <= mem[rd_ptr];
                    rd_ptr <= (rd_ptr + 1) % DEPTH;
                end
            end
        end
    end

endmodule