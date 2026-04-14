module top_module(
    input pb_signal,
    input clk_write,
    input [11:0] data_in,
    output reg [11:0] data_out,
    output reg [4:0] led = 0
    );reg [11:0] memory [0:100002];
    reg [16:0] i = 0;
    reg [16:0] j = 1; 
    reg [16:0] z = 0; 
    
    always @ (posedge pb_signal) begin 
        z <= (z == 100000) ? 0: z + 20000; 
        led <= (led == 5) ? 0 : led+1; 
    end
        
    always @ (posedge clk_write) begin
        memory[i] <= data_in;
        data_out <= memory[j];
        i <= (i == z) ? 0 : i+1; 
        j <= (j == z) ? 0 : j+1;
    end
        
endmodule