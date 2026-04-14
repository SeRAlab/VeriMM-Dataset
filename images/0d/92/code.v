module data_forwarding_mux(  
    input wire [7:0] in0,  
    input wire [7:0] in1,  
    input wire sel,  
    output reg [7:0] out  
);  
    reg [7:0] previous_out;  
     
    always @(*) begin  
        if (sel) begin  
            if (in0 == previous_out)  
                out = in0;  
            else  
                out = in0;  
        end else begin  
            previous_out = out;  
            out = in1;  
        end  
    end  
endmodule