module sample_rate_converter(  
    input clk,  
    input rst,  
    input sample,  
    input [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [1:0] counter;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            counter <= 2'd0;  
            data_out <= 8'd0;  
        end else begin  
            if (sample) begin  
                counter <= counter + 2'd1;  
                if (counter == 2'd1) begin  
                    data_out <= data_in;  
                end  
            end  
        end  
    end  
endmodule