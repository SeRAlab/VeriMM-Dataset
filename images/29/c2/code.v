module ethernet_mac_controller(  
    input wire clk,  
    input wire data_in,  
    output reg data_out  
);  
    reg [1:0] shift_reg;  

    always @(posedge clk) begin  
        shift_reg <= {shift_reg[0], data_in};  
        data_out <= shift_reg[1];  
    end  
endmodule