module chebyshev_filter (  
    input [4:0] signal_in,  
    input [4:0] ripple,  
    output reg [4:0] signal_out  
);  
    always @(*) begin  
        // Simulating a basic Chebyshev filter operation  
        // For simplicity, we apply a simple transfer function  
        signal_out = (signal_in > ripple) ? ripple : signal_in;  
    end  
endmodule