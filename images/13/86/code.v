module sample_rate_converter #(parameter INPUT_RATE = 1, parameter OUTPUT_RATE = 4) (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    integer counter;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 0;  
            data_out <= 0;  
        end else begin  
            if (counter < OUTPUT_RATE - 1) begin  
                counter <= counter + 1;  
            end else begin  
                data_out <= data_in;  
                counter <= 0;  
            end  
        end  
    end  
endmodule