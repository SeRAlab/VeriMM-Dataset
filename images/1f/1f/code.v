module sample_rate_converter (  
    input clk,  
    input rst,  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [1:0] counter;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            counter <= 0;  
            data_out <= 8'd0;  
        end else begin  
            if (counter == 2'b01) begin  
                data_out <= data_in;  
            end  
            counter <= counter + 1;  
            if (counter == 2'b10) begin  
                counter <= 0;  
            end  
        end  
    end  
endmodule