module top_module(
    input clk,
    input rst,
    input start,
    input mem_read,
    input mem_write,
    input [7:0] adc_data,
    input [9:0] mem_addr,
    input [7:0] mem_data,
    output reg [7:0] mem_out // Changed from wire to reg
);reg [7:0] mem [1023:0];
    reg [1:0] state;
    reg [7:0] channel0_data;
    reg [7:0] channel1_data;
    reg [9:0] mem_address;
    
    always @(posedge clk) begin
        if (rst) begin
            state <= 2'b00;
            mem_address <= 10'b0;
        end else begin
            case (state)
                2'b00: begin // Idle state
                    if (start) begin
                        state <= 2'b01;
                    end else if (mem_read) begin
                        mem_out <= mem[mem_address];
                        state <= 2'b10;
                    end else if (mem_write) begin
                        mem[mem_address] <= mem_data;
                        state <= 2'b10;
                    end
                end
                2'b01: begin // Read from ADCs
                    channel0_data <= adc_data;
                    state <= 2'b10;
                end
                2'b10: begin // Write to memory
                    mem[mem_address] <= channel0_data;
                    mem_address <= mem_address + 1;
                    if (mem_address == 10'b1111111111) begin
                        state <= 2'b00;
                    end else begin
                        state <= 2'b01;
                    end
                end
            endcase
        end
    end
    
endmodule