module top_module(
    input clk,
    input [63:0] din,
    input wr_en,
    input [1:0] wr_addr,
    input rd_en,
    input [1:0] rd_addr,
    output reg [63:0] dout,
    output reg full
);reg [15:0] mem_0 [0:255];
reg [15:0] mem_1 [0:255];
reg [15:0] mem_2 [0:255];
reg [15:0] mem_3 [0:255];
reg [7:0] write_count [0:3]; // Address write counters for each memory bank

initial begin
    full = 1'b0;
    write_count[0] = 0;
    write_count[1] = 0;
    write_count[2] = 0;
    write_count[3] = 0;
end

always @(posedge clk) begin
    if (wr_en) begin
        case (wr_addr)
            2'b00: begin
                if (write_count[0] < 256) begin
                    mem_0[write_count[0]] <= din[15:0];
                    write_count[0] <= write_count[0] + 1;
                end else begin
                    full <= 1'b1;
                end
            end
            2'b01: begin
                if (write_count[1] < 256) begin
                    mem_1[write_count[1]] <= din[15:0];
                    write_count[1] <= write_count[1] + 1;
                end else begin
                    full <= 1'b1;
                end
            end
            2'b10: begin
                if (write_count[2] < 256) begin
                    mem_2[write_count[2]] <= din[15:0];
                    write_count[2] <= write_count[2] + 1;
                end else begin
                    full <= 1'b1;
                end
            end
            2'b11: begin
                if (write_count[3] < 256) begin
                    mem_3[write_count[3]] <= din[15:0];
                    write_count[3] <= write_count[3] + 1;
                end else begin
                    full <= 1'b1;
                end
            end
        endcase
    end
    
    if (rd_en) begin
        case (rd_addr)
            2'b00: dout <= {mem_0[write_count[0]-1], 48'h000000000000}; // Shift higher order bits
            2'b01: dout <= {mem_1[write_count[1]-1], 48'h000000000000};
            2'b10: dout <= {mem_2[write_count[2]-1], 48'h000000000000};
            2'b11: dout <= {mem_3[write_count[3]-1], 48'h000000000000};
        endcase
    end else begin
        dout <= 64'b0; // Reset output if no read
    end
end

endmodule