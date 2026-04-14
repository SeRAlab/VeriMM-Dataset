module shift_register(  
    input clk,  
    input rst,  
    input load,  
    input direction, // 0 for left shift, 1 for right shift  
    input [7:0] in_data,  
    output reg [7:0] out_data  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            out_data <= 8'b0;  
        else if (load)  
            out_data <= in_data;  
        else if (direction)  // right shift  
            out_data <= {1'b0, out_data[7:1]};  
        else  // left shift  
            out_data <= {out_data[6:0], 1'b0};  
    end  
endmodule