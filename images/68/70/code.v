module top_module(
    input CLK,
    input nRST,
    input in_enq__ENA,
    input [31:0] in_enq_v,
    output in_enq__RDY,
    input out_deq__ENA,
    output out_deq__RDY,
    output reg [31:0] out_first,  // Change from wire to reg
    output out_first__RDY
);reg [31:0] fifo_mem [0:7];
    reg [2:0] wr_ptr;
    reg [2:0] rd_ptr;
    reg empty;
    reg full;
    reg [2:0] count;

    assign in_enq__RDY = ~full;
    assign out_deq__RDY = ~empty;
    assign out_first__RDY = ~empty;

    always @ (posedge CLK) begin
        if (!nRST) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            empty <= 1;
            full <= 0;
            count <= 0;
            out_first <= 0; // Initialize out_first on reset
        end else begin
            if (in_enq__ENA && !full) begin
                fifo_mem[wr_ptr] <= in_enq_v;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
                if (wr_ptr == 7) begin
                    wr_ptr <= 0;
                end
                if (count == 7) begin
                    full <= 1;
                end
                empty <= 0;
            end
            if (out_deq__ENA && !empty) begin
                out_first <= fifo_mem[rd_ptr]; // Note: now valid since out_first is reg
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
                if (rd_ptr == 7) begin
                    rd_ptr <= 0;
                end
                if (count == 1) begin
                    empty <= 1;
                end
                full <= 0;
            end
        end
    end

endmodule