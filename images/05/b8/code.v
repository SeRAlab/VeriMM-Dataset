module ethernet_mac_controller (  
    input clk,  
    input reset,  
    input [63:0] data_in,  
    input control,  // control signal: 1 for transmit, 0 for receive  
    output reg [63:0] data_out  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        data_out <= 64'b0;  
    end else begin  
        if (control) begin  // Transmit  
            data_out <= data_in;  
        end  
        // If receiving, data_out retains the last received data due to the way register works  
    end  
end  
endmodule