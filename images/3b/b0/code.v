module dma_controller(
    input wire clk,
    input wire reset,
    input wire start_transfer,
    input wire [7:0] source_addr,
    input wire [7:0] dest_addr,
    input wire [3:0] transfer_size,
    output reg transfer_complete,
    output reg [7:0] data_out,
    output reg write_enable
);
    reg [3:0] counter;
    reg [7:0] current_addr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            transfer_complete <= 0;
            counter <= 0;
            current_addr <= 0;
            write_enable <= 0;
        end else begin
            if (start_transfer) begin
                current_addr <= source_addr;
                counter <= transfer_size;
                transfer_complete <= 0;
                write_enable <= 1;
            end
            
            if (counter > 0) begin
                data_out <= current_addr; // Simulate data read from source
                current_addr <= current_addr + 1;
                counter <= counter - 1;
            end else if (counter == 0 && write_enable) begin
                write_enable <= 0; // Stop writing
                transfer_complete <= 1; // Indicate transfer complete
            end
        end
    end
endmodule