module ARQSystem (  
    input [4:0] data_in,  
    input ack,  
    output reg [4:0] data_out  
);  
    // Error correction logic  
    always @(data_in or ack) begin  
        if (ack) begin  
            data_out = data_in; // Acknowledged, output data as is  
        end else begin  
            data_out = 5'b11111; // Error occurred, output default error code  
        end  
    end  
endmodule