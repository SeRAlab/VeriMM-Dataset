module spi_controller(  
    input wire clk,  
    input wire cs,  
    input wire mosi,  
    output reg miso,  
    output reg [7:0] received_data,  
    output reg [7:0] sent_data,  
    input wire [7:0] command,  
    input wire [7:0] data,  
    input wire start  
);  
    reg [3:0] bit_count;  
    reg state;  
    
    always @(posedge clk or negedge cs) begin  
        if (!cs) begin  
            state <= 1;  
            bit_count <= 0;  
            received_data <= 8'b0;  
            miso <= 1'b0;  
        end else if (state) begin  
            if (bit_count < 8) begin  
                miso <= data[7 - bit_count];  
                if (mosi) begin  
                    received_data[7 - bit_count] <= mosi;  
                end  
                bit_count <= bit_count + 1;  
            end else begin  
                state <= 0;  
            end  
        end  
    end  
endmodule