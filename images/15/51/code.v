module SD_Card_Controller (
    input clk,
    input reset,
    input read_req,
    input write_req,
    input [1:0] block_addr,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:3]; // 4 blocks of 8-bit data
    reg [1:0] current_addr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
            current_addr <= 2'b0;
            // initializing memory
            memory[0] <= 8'b0;
            memory[1] <= 8'b0;
            memory[2] <= 8'b0;
            memory[3] <= 8'b0;
        end else begin
            current_addr <= block_addr;
            if (write_req) begin
                memory[block_addr] <= data_in; // write data to the specified block
            end
            if (read_req) begin
                data_out <= memory[block_addr]; // read data from the specified block
            end
        end
    end
endmodule