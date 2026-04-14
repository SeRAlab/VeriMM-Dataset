module top_module(
    input clk,
    input wr_req,
    input [7:0] wr_data,
    input rd_req,
    output reg [7:0] rd_data,  // Changed to reg
    output reg wr_ack
);reg [7:0] mem [0:7];
reg [2:0] wr_ptr = 0;
reg [2:0] rd_ptr = 0;
reg [2:0] count = 0;

always @(posedge clk) begin
    wr_ack <= (count < 8) ? 1'b1 : 1'b0;  // Moved wr_ack assignment outside of the write condition

    if (wr_req && (count < 8)) begin
        mem[wr_ptr] <= wr_data;
        wr_ptr <= wr_ptr + 1;
        count <= count + 1;
    end

    if (rd_req && (count > 0)) begin
        rd_data <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
        count <= count - 1;
    end
end

endmodule