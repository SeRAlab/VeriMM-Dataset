module shift_register (  
    input wire clk,  
    input wire load,  
    input wire [1:0] data_in,  
    output reg [1:0] data_out  
);  
    initial begin  
        data_out = 2'b00;  
    end  

    always @(posedge clk) begin  
        if (load) begin  
            data_out <= data_in;  
        end else begin  
            data_out <= {1'b0, data_out[1]};  
        end  
    end  
endmodule