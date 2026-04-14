module top_module( 
    input clock,
    input [31:0] data,
    output empty,
    output full,
    output reg [31:0] q, // Changed to reg since q is assigned in always block
    input rreq,
    input sclr,
    output reg [4:0] usedw, // Changed to reg since usedw is assigned in always block
    input wreq
    );reg [31:0] mem [15:0];
    reg [4:0] wr_ptr = 0;
    reg [4:0] rd_ptr = 0;
    reg [4:0] wr_cnt = 0;
    reg [4:0] rd_cnt = 0;
    // Removed usedw_reg and use usedw directly
    wire [4:0] wr_ptr_next = wr_ptr + 1;
    wire [4:0] rd_ptr_next = rd_ptr + 1;

    always @(posedge clock) begin
        if (sclr) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            wr_cnt <= 0;
            rd_cnt <= 0;
            usedw <= 0; // Updated usedw directly
            q <= 0;     // Reset q as well
        end else begin
            if (wreq && !full) begin
                mem[wr_ptr] <= data;
                wr_ptr <= wr_ptr_next;
                wr_cnt <= wr_cnt + 1;
            end
            if (rreq && !empty) begin
                q <= mem[rd_ptr];
                rd_ptr <= rd_ptr_next;
                rd_cnt <= rd_cnt + 1;
            end
            usedw <= wr_cnt - rd_cnt; // Updated usedw directly
        end
    end

    assign empty = (wr_cnt == rd_cnt);
    assign full = (wr_cnt == 16);

endmodule