module top_module(
    aclr,
    clock,
    data,
    rdreq,
    wrreq,
    q,
    usedw
);input aclr;
input clock;
input [29:0] data;
input rdreq;
input wrreq;
output [29:0] q;
output [4:0] usedw;

reg [29:0] buffer [31:0];
reg [4:0] usedw_reg;
reg [4:0] wr_ptr;  // Write pointer
reg [4:0] rd_ptr;  // Read pointer
reg [29:0] q_reg;
reg wr_en;
reg rd_en;

always @(posedge clock or negedge aclr) begin
    if (~aclr) begin
        usedw_reg <= 0;
        wr_ptr <= 0;
        rd_ptr <= 0;
        q_reg <= 0;
    end
    else begin
        wr_en <= wrreq && (usedw_reg < 32);
        rd_en <= rdreq && (usedw_reg > 0);
        
        if (wr_en) begin
            buffer[wr_ptr] <= data;
            wr_ptr <= (wr_ptr + 1) % 32;
            usedw_reg <= usedw_reg + 1;
        end
        
        if (rd_en) begin
            q_reg <= buffer[rd_ptr];
            buffer[rd_ptr] <= 0; // Clear the buffer after reading
            rd_ptr <= (rd_ptr + 1) % 32;
            usedw_reg <= usedw_reg - 1;
        end
    end
end

assign q = q_reg;
assign usedw = usedw_reg;

endmodule