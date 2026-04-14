module spi_controller (  
    input wire clk,  
    input wire cs,  // Chip Select  
    input wire mosi, // Master Out Slave In  
    output reg miso, // Master In Slave Out  
    output reg [7:0] data_out,  
    output reg ready  
);  

    reg [2:0] bit_cnt;  
    reg [7:0] data_in;  

    always @(posedge clk or negedge cs) begin  
        if (!cs) begin  
            bit_cnt <= 3'b000;  
            data_in <= 8'b0;  
            ready <= 1'b0;  
        end else begin  
            if (bit_cnt < 3'b111) begin  
                data_in <= {data_in[6:0], mosi};  
                bit_cnt <= bit_cnt + 1;  
            end else begin  
                data_out <= data_in;  
                miso <= data_in[7];  
                ready <= 1'b1;  
                bit_cnt <= 3'b000;  
                data_in <= 8'b0;  
            end  
        end  
    end  
endmodule