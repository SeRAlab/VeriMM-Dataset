module adc_controller(  
    input clk,  
    input reset,  
    input [23:0] data_in,  
    output reg [23:0] data_out,  
    output reg valid  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 24'b0;  
            valid <= 1'b0;  
        end else begin  
            if (data_in <= 24'hFFFFFF) begin  
                data_out <= data_in;  
                valid <= 1'b1;  
            end else begin  
                data_out <= 24'b0;  
                valid <= 1'b0;  
            end  
        end  
    end  
endmodule