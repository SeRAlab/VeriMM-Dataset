module bluetooth_status_checker(  
    input wire connection_status,  
    input wire enable,  
    output reg status_message  
);  
  
always @(*) begin  
    if (enable) begin  
        status_message = connection_status;  
    end else begin  
        status_message = 0;  
    end  
end  
endmodule