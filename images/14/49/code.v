module reset_controller #(  
    parameter NUM_CYCLES = 5  
)(  
    input wire clk,  
    input wire reset_in,  
    output reg reset_out  
);  

reg [3:0] counter;  

always @(posedge clk or posedge reset_in) begin  
    if (reset_in) begin  
        counter <= 0;  
        reset_out <= 1;  
    end else if (counter < NUM_CYCLES) begin  
        counter <= counter + 1;  
        reset_out <= 1;  
    end else begin  
        reset_out <= 0;  
    end  
end  
endmodule