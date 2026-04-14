module mux_4to1_forward(input [7:0] in0, in1, in2, in3,  
                         input [1:0] sel,  
                         output reg [7:0] out);  
                         
    reg [7:0] prev_out;  

    always @(*) begin  
        if (sel == 2'b00) begin  
            out = in0;  
        end else if (sel == 2'b01) begin  
            out = in1;  
        end else if (sel == 2'b10) begin  
            out = in2;  
        end else if (sel == 2'b11) begin  
            out = in3;  
        end  

        // Data forwarding logic  
        if (out == prev_out) begin  
            out = prev_out;  
        end else begin  
            prev_out = out;  
        end  
    end  
endmodule