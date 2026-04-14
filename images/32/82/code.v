module fixed_priority_arbiter (  
    input wire clk,  
    input wire reset,  
    input wire [3:0] req,  
    output reg [3:0] grant  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            grant <= 4'b0000;  
        end else begin  
            case (1'b1)  
                req[0]: grant <= 4'b0001; // REQ0 has the highest priority  
                req[1]: grant <= 4'b0010; // REQ1 has the second priority  
                req[2]: grant <= 4'b0100; // REQ2 has the third priority  
                req[3]: grant <= 4'b1000; // REQ3 has the lowest priority  
                default: grant <= 4'b0000; // No requests  
            endcase  
        end  
    end  
endmodule