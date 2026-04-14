module top_module(
    input clk,
    input rst_n,
    input write_en,
    input [2:0] control,
    input [7:0] write_addr,
    input [3:0] write_data,
    input [7:0] read_addr_1,
    input [7:0] read_addr_2,
    output reg [3:0] read_data_1,
    output reg [3:0] read_data_2,
    output reg [3:0] result
);reg [3:0] ram [0:7];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        read_data_1 <= 4'b0;
        read_data_2 <= 4'b0;
        result <= 4'b0;
    end else begin
        if (write_en) begin
            ram[write_addr[2:0]] <= write_data;
        end

        read_data_1 <= ram[read_addr_1[2:0]];
        read_data_2 <= ram[read_addr_2[2:0]];

        case (control)
            3'b000: result <= read_data_1 + read_data_2;
            3'b001: result <= read_data_1 - read_data_2;
            default: result <= 4'b0;
        endcase
    end
end

endmodule