module piso_shift_register (  
    input wire clk,  
    input wire load,  
    input wire shift,  
    input wire [7:0] data_in,  
    output reg serial_out  
);  
    reg [7:0] register;  
    integer count;  

    always @(posedge clk) begin  
        if (load) begin  
            register <= data_in;  
            count <= 0;  
        end else if (shift) begin  
            serial_out <= register[7];  
            register <= {register[6:0], 1'b0};  
            count <= count + 1;  
        end  
    end  
endmodule