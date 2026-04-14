module top_module(
    input clk,
    input rst_n,
    input write_en,
    input [3:0] write_addr,
    input [7:0] write_data,
    input read_en,
    input [3:0] read_addr,
    output reg [7:0] read_data
);reg [7:0] ram0 [0:15];
reg [7:0] ram1 [0:15];

reg [7:0] ram0_data;
reg [7:0] ram1_data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data <= 8'hFF;
    end else begin
        if (read_en) begin
            ram0_data <= ram0[read_addr];
            ram1_data <= ram1[read_addr];
        end
        if (write_en) begin
            ram0[write_addr] <= write_data;
            ram1[write_addr] <= write_data;
        end
    end
end

always @(posedge clk) begin
    if (read_en) begin
        case (read_addr[3])
            1'b0: read_data <= ram0_data;
            1'b1: read_data <= ram1_data;
        endcase
    end
end

endmodule