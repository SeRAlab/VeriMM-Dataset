module audio_mixer(  
    input clk,  
    input enable,  
    input [7:0] A,  
    input [7:0] B,  
    output reg [7:0] Y  
);  
    always @(posedge clk) begin  
        if (enable) begin  
            Y <= (A + B) >> 1; // Mixing operation  
        end  
    end  
endmodule