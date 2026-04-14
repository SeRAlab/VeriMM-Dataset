module SubBytes (
    input wire clk,
    input wire rst,
    input wire [127:0] data_in,
    output reg [127:0] data_out
);
    
    // AES S-Box (substitution box)
    reg [7:0] s_box [0:255];
    
    initial begin
        // Initialize the S-Box with values of the AES S-Box
        s_box[8'h00] = 8'h63; s_box[8'h01] = 8'h7c; s_box[8'h02] = 8'h77; s_box[8'h03] = 8'h7b;
        s_box[8'h04] = 8'hf2; s_box[8'h05] = 8'h6b; s_box[8'h06] = 8'h6f; s_box[8'h07] = 8'hc5;
        s_box[8'h08] = 8'h30; s_box[8'h09] = 8'h01; s_box[8'h0a] = 8'h67; s_box[8'h0b] = 8'h2b;
        s_box[8'h0c] = 8'hfe; s_box[8'h0d] = 8'hd7; s_box[8'h0e] = 8'hab; s_box[8'h0f] = 8'h76;
        // ... populate the rest of the S-Box ...
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 128'b0;
        end else begin
            data_out[127:120] <= s_box[data_in[127:120]];
            data_out[119:112] <= s_box[data_in[119:112]];
            data_out[111:104] <= s_box[data_in[111:104]];
            data_out[103:96]  <= s_box[data_in[103:96]];
            data_out[95:88]   <= s_box[data_in[95:88]];
            data_out[87:80]   <= s_box[data_in[87:80]];
            data_out[79:72]   <= s_box[data_in[79:72]];
            data_out[71:64]   <= s_box[data_in[71:64]];
            data_out[63:56]   <= s_box[data_in[63:56]];
            data_out[55:48]   <= s_box[data_in[55:48]];
            data_out[47:40]   <= s_box[data_in[47:40]];
            data_out[39:32]   <= s_box[data_in[39:32]];
            data_out[31:24]   <= s_box[data_in[31:24]];
            data_out[23:16]   <= s_box[data_in[23:16]];
            data_out[15:8]    <= s_box[data_in[15:8]];
            data_out[7:0]     <= s_box[data_in[7:0]];
        end
    end
endmodule