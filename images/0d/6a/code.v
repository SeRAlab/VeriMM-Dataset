module ethernet_mac_controller(  
    input clk,  
    input reset,  
    input set_status,  
    input clear_status,  
    output reg [1:0] status  
);  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            status <= 2'b00; // Reset status to '00'  
        end else begin  
            if (set_status) begin  
                status <= 2'b01; // Set status to '01'  
            end else if (clear_status) begin  
                status <= 2'b00; // Clear status to '00'  
            end  
        end  
    end  
endmodule