module timer_32bit (  
    input wire clk,  
    input wire reset,  
    input wire load,  
    input wire [31:0] load_value,  
    output reg [31:0] timer_value  
);  
  
always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        timer_value <= 32'b0;  
    end else if (load) begin  
        timer_value <= load_value;  
    end else begin  
        timer_value <= timer_value + 1;  
    end  
end  
endmodule