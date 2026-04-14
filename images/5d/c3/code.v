module top_module(
    input clk,
    input rd,
    input reset_n,
    input wr,
    input [7:0] wr_data,
    output almost_empty,
    output almost_full,
    output empty,
    output full,
    output reg [7:0] rd_data
);reg [7:0] entry_0;
    reg [7:0] entry_1;
    reg [1:0] wr_address;
    reg [1:0] rd_address;
    reg [1:0] entries;
    
    assign almost_empty = (entries <= 1) ? 1'b1 : 1'b0;
    assign almost_full = (entries >= 1) ? 1'b1 : 1'b0;
    assign empty = (entries == 0) ? 1'b1 : 1'b0;
    assign full = (entries == 2) ? 1'b1 : 1'b0;
    
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            wr_address <= 2'b00;
            rd_address <= 2'b00;
            entries <= 0;
            rd_data <= 0;
        end else begin
            if (wr & ~full) begin
                case (wr_address)
                    2'b00: entry_0 <= wr_data;
                    2'b01: entry_1 <= wr_data;
                endcase
                wr_address <= (wr_address == 2'b01) ? 2'b00 : wr_address + 1;
                entries <= entries + 1;
            end
            if (rd & ~empty) begin
                case (rd_address)
                    2'b00: rd_data <= entry_0;
                    2'b01: rd_data <= entry_1;
                endcase
                rd_address <= (rd_address == 2'b01) ? 2'b00 : rd_address + 1;
                entries <= entries - 1;
            end
        end
    end
    
endmodule