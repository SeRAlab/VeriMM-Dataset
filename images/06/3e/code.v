module power_gating (  
    input wire power_control,  
    input wire [3:0] data_input,  
    output reg [3:0] data_output  
);  
    always @(*) begin  
        if (power_control)  
            data_output = data_input;  
        else  
            data_output = 4'b0000;  
    end  
endmodule