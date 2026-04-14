module mac_address_generator(  
    input clk,  
    input reset,  
    output reg [47:0] mac_address  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            mac_address <= 48'h000000000000;  
        end else begin  
            if (mac_address == 48'hFFFFFFFFFFFF)  
                mac_address <= 48'h000000000000;  
            else  
                mac_address <= mac_address + 1;  
        end  
    end  
endmodule