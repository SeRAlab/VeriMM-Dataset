module fixed_priority_arbiter (  
    input wire clk,  
    input wire rst,  
    input wire [3:0] request,  
    output reg [3:0] grant  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 4'b0000;  
        end else begin  
            case (request)  
                4'b0001: grant <= 4'b0001; // R0  
                4'b0010: grant <= 4'b0010; // R1  
                4'b0100: grant <= 4'b0100; // R2  
                4'b1000: grant <= 4'b1000; // R3  
                4'b0011: grant <= 4'b0001; // R0, R1  
                4'b0110: grant <= 4'b0010; // R1, R2  
                4'b1100: grant <= 4'b0100; // R2, R3  
                4'b1111: grant <= 4'b0001; // All active, grant R0  
                default: grant <= 4'b0000; // No request  
            endcase  
        end  
    end  
endmodule