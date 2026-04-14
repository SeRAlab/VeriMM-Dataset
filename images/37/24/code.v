module echo_cancellation #(parameter WIDTH = 8) (  
    input clk,  
    input reset,  
    input [WIDTH-1:0] signal_in,  
    input [WIDTH-1:0] echo_ref,  
    input [WIDTH-1:0] gain,  
    output reg [WIDTH-1:0] signal_out  
);  
    reg [WIDTH-1:0] echo_delayed;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            echo_delayed <= 0;  
            signal_out <= 0;  
        end else begin  
            echo_delayed <= echo_ref;  
            signal_out <= signal_in - (gain * echo_delayed);  
        end  
    end  
endmodule