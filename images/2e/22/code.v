module dma_controller (
    input wire clk,
    input wire reset,
    input wire channel1_enable,
    input wire channel2_enable,
    input wire [7:0] channel1_data,
    input wire [7:0] channel2_data,
    output reg [7:0] mem_data,
    output reg channel1_state, // 0: idle, 1: reading, 2: writing
    output reg channel2_state  // 0: idle, 1: reading, 2: writing
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mem_data <= 8'b0;
            channel1_state <= 0;
            channel2_state <= 0;
        end else begin
            if (channel1_enable) begin
                channel1_state <= 1; // set to reading
                mem_data <= channel1_data; // read data
                channel1_state <= 2; // set to writing
            end else begin
                channel1_state <= 0; // set to idle
            end
            
            if (channel2_enable) begin
                channel2_state <= 1; // set to reading
                mem_data <= channel2_data; // read data
                channel2_state <= 2; // set to writing
            end else begin
                channel2_state <= 0; // set to idle
            end
        end
    end
endmodule