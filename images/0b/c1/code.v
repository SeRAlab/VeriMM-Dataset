module shift_register (  
    input wire clk,  
    input wire reset,  
    input wire load,  
    input wire [1:0] data_in,  
    output reg [1:0] data_out  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 2'b00;  
        end else if (load) begin  
            data_out <= {data_out[0], data_in[0]};  
        end else begin  
            data_out <= {data_out[1], data_out[0]};  
        end  
    end  
endmodule