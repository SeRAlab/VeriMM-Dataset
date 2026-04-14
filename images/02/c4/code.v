module VCO (  
    input wire clk,  
    input wire [3:0] ctrl_v,  
    output reg osc_out  
);  
    reg [31:0] counter;  
    always @(posedge clk) begin  
        counter <= counter + 1;  
        if (counter >= (1 << ctrl_v)) begin  
            osc_out <= ~osc_out;  
            counter <= 0;  
        end  
    end  
endmodule