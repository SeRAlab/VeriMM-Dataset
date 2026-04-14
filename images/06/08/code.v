module shift_register (  
    input clk,  
    input reset,  
    input enable,  
    input [1:0] data_in,  
    output reg [1:0] q  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            q <= 2'b00;  
        else if (enable)  
            q <= {data_in[0], q[1]};  
    end  
endmodule