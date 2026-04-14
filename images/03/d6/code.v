module shift_register(  
    input wire clk,  
    input wire reset,  
    input wire direction, // 0 for left shift, 1 for right shift  
    input wire [7:0] data_in,  
    output reg [7:0] data_out  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 8'b0;  
        end else begin  
            if (direction) begin  
                // Right shift with rotation  
                data_out <= {data_out[0], data_out[7:1]};  
            end else begin  
                // Left shift with rotation  
                data_out <= {data_out[6:0], data_out[7]};  
            end  
        end  
    end  
endmodule