module spi_controller (  
    input wire clk,  
    input wire reset,  
    input wire enable,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out,  
    output reg sclk,  
    output reg mosi,  
    input wire miso,  
    output reg ss  
);  
    reg [2:0] bit_count;  
    reg [7:0] shift_reg;  
    reg state; // 0 for idle, 1 for sending  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sclk <= 0;  
            mosi <= 0;  
            ss <= 1;  
            data_out <= 8'b0;  
            bit_count <= 0;  
            state <= 0;  
        end else if (enable) begin  
            ss <= 0;  
            if (state == 0) begin  
                shift_reg <= data_in;  
                bit_count <= 7;  
                state <= 1;  
            end else if (bit_count >= 0) begin  
                sclk <= ~sclk;  
                if (sclk) begin  
                    mosi <= shift_reg[bit_count];  
                end else begin  
                    data_out[bit_count] <= miso;  
                    bit_count <= bit_count - 1;  
                end  
            end else begin  
                ss <= 1;  
                state <= 0;  
            end  
        end  
    end  
endmodule