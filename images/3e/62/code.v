module AES_SBox (  
    input [7:0] in_data,  
    output reg [7:0] out_data,  
    input clk,  
    input reset  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset)  
            out_data <= 8'b0;  
        else begin  
            case(in_data)  
                8'h00: out_data <= 8'h63;  
                8'h01: out_data <= 8'h7c;  
                8'h02: out_data <= 8'h77;  
                8'h03: out_data <= 8'h7b;  
                8'h04: out_data <= 8'hf2;  
                8'h05: out_data <= 8'h6b;  
                8'h06: out_data <= 8'h6f;  
                8'h07: out_data <= 8'hc5;  
                8'h08: out_data <= 8'h30;  
                8'h09: out_data <= 8'h01;  
                8'h0a: out_data <= 8'h67;  
                8'h0b: out_data <= 8'h2b;  
                8'h0c: out_data <= 8'hfe;  
                8'h0d: out_data <= 8'hd7;  
                8'h0e: out_data <= 8'hab;  
                8'h0f: out_data <= 8'h76;  
                // Add remaining S-box values here...  
                default: out_data <= 8'h00;  
            endcase  
        end  
    end  
endmodule