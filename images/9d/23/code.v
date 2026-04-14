module top_module(
    input clk,
    input reset_n,
    input wr,
    input [7:0] wr_data,
    input rd,
    output reg [7:0] rd_data,
    output empty,
    output full,
    output almost_empty,
    output almost_full
    );reg [7:0] memory [1:0];
    reg [1:0] rd_address;
    reg [1:0] wr_address;
    reg [1:0] entries;

    assign full = (entries == 2);
    assign empty = (entries == 0);
    assign almost_full = (entries == 1);
    assign almost_empty = (entries == 1);
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            rd_address <= 2'b0;
            wr_address <= 2'b0;
            entries <= 2'b0;
        end else begin
            if (wr & !full) begin
                memory[wr_address] <= wr_data;
                wr_address <= (wr_address == 2'b1) ? 2'b0 : (wr_address + 1);
                entries <= entries + 1;
            end
            if (rd & !empty) begin
                rd_data <= memory[rd_address];
                rd_address <= (rd_address == 2'b1) ? 2'b0 : (rd_address + 1);
                entries <= entries - 1;
            end
        end
    end
    
endmodule