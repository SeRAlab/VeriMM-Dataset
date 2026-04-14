module fixed_priority_arbiter(  
    input wire clk,  
    input wire rst,  
    input wire [4:0] request,  // 5 requests from 5 masters  
    output reg [4:0] grant     // Grant signal to the highest priority master  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            grant <= 5'b00000;  
        end else begin  
            case (request)  
                5'b1xxxx: grant <= 5'b00001; // Master 0 has the highest priority  
                5'b01xxx: grant <= 5'b00010; // Master 1  
                5'b001xx: grant <= 5'b00100; // Master 2  
                5'b0001x: grant <= 5'b01000; // Master 3  
                5'b00001: grant <= 5'b10000; // Master 4  
                default:  grant <= 5'b00000;  // No grant  
            endcase  
        end  
    end  
endmodule