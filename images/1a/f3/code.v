module divide_by_8(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  
    reg [7:0] counter;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            counter <= 0;  
            data_out <= 0;  
        end else if (counter == 7) begin  
            counter <= 0;  
            data_out <= data_in >> 3;  
        end else begin  
            counter <= counter + 1;  
        end  
    end  
endmodule