module top_module(
    input clk,
    input rst_n,
    input write_en,
    input [7:0] write_addr,
    input [3:0] write_data,
    input read_en,
    input [7:0] read_addr,
    output reg [3:0] read_data
);reg [3:0] mem [0:7];
reg [3:0] read_data_reg;
reg [7:0] write_addr_reg;
reg [3:0] write_data_reg;
reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
        read_data_reg <= 4'b0;
        write_addr_reg <= 8'b0;
        write_data_reg <= 4'b0;
    end else begin
        case (state)
            2'b00: begin
                if (write_en) begin
                    write_addr_reg <= write_addr;
                    write_data_reg <= write_data;
                    state <= 2'b01;
                end else if (read_en) begin
                    read_data_reg <= mem[read_addr];
                    state <= 2'b10;
                end
            end
            2'b01: begin
                mem[write_addr_reg] <= write_data_reg;
                state <= 2'b00;
            end
            2'b10: begin
                read_data <= read_data_reg;
                state <= 2'b00;
            end
        endcase
    end
end

endmodule