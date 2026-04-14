module AdaptiveLMSFilter(  
    input clk,  
    input reset,  
    input [15:0] x, // input signal  
    input [7:0] error, // error signal  
    input [7:0] step_size, // adaptation step size  
    output reg [15:0] y // output signal  
);  
    reg [15:0] w; // filter coefficient  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            w <= 16'b0;  
            y <= 16'b0;  
        end else begin  
            y <= (w * x) >> 8; // output calculation (scaled)  
            w <= w + ((error * step_size) >> 8); // coefficient update  
        end  
    end  
endmodule