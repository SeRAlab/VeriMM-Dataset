module des_round (  
    input clk,  
    input reset,  
    input [7:0] data_in,  
    input [55:0] key,  
    output reg [7:0] data_out  
);  
  
    // Simple substitution box  
    reg [7:0] s_box [0:15];  
    initial begin  
        s_box[0] = 8'h63;  
        s_box[1] = 8'h7c;  
        s_box[2] = 8'h77;  
        s_box[3] = 8'h7b;  
        s_box[4] = 8'hf2;  
        s_box[5] = 8'h6b;  
        s_box[6] = 8'h6f;  
        s_box[7] = 8'hc5;  
        s_box[8] = 8'h30;  
        s_box[9] = 8'h01;  
        s_box[10] = 8'h67;  
        s_box[11] = 8'h2b;  
        s_box[12] = 8'hfe;  
        s_box[13] = 8'hd7;  
        s_box[14] = 8'hab;  
        s_box[15] = 8'h76;  
    end  
  
    // Simple permutation table  
    reg [7:0] perm_table [0:7];  
    initial begin  
        perm_table[0] = 8'h02;  
        perm_table[1] = 8'h03;  
        perm_table[2] = 8'h01;  
        perm_table[3] = 8'h05;  
        perm_table[4] = 8'h04;  
        perm_table[5] = 8'h07;  
        perm_table[6] = 8'h06;  
        perm_table[7] = 8'h00;  
    end  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            data_out <= 8'b0;  
        end else begin  
            // Substitute  
            data_out <= s_box[data_in[3:0]] ^ key[7:0];  
            // Permute  
            data_out <= perm_table[data_out[3:0]];  
        end  
    end  
endmodule