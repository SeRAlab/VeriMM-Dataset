module fixed_priority_arbiter (  
    input wire clk,  
    input wire rst,  
    input wire [3:0] request, // 4 request lines  
    output reg [3:0] grant    // 4 grant lines  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 4'b0000;  
        end else begin  
            case (request)  
                4'b1000: grant <= 4'b1000; // Priority 0  
                4'b0100: grant <= 4'b0100; // Priority 1  
                4'b0010: grant <= 4'b0010; // Priority 2  
                4'b0001: grant <= 4'b0001; // Priority 3  
                default: grant <= 4'b0000; // No request  
            endcase  
        end  
    end  
endmodule