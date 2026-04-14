module gpio_controller(  
    input wire [4:0] switch,  
    input wire enable,  
    output reg [4:0] led  
);  
    always @(posedge enable) begin  
        if (enable) begin  
            led <= switch;  
        end else begin  
            led <= 5'b00000;  
        end  
    end  
endmodule