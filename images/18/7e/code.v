module mux32to1 (
    input [31:0] data,
    input [4:0] sel,
    output reg out
);
    always @(*) begin
        case(sel)
            5'd0: out = data[0];
            5'd1: out = data[1];
            5'd2: out = data[2];
            5'd3: out = data[3];
            5'd4: out = data[4];
            5'd5: out = data[5];
            5'd6: out = data[6];
            5'd7: out = data[7];
            5'd8: out = data[8];
            5'd9: out = data[9];
            5'd10: out = data[10];
            5'd11: out = data[11];
            5'd12: out = data[12];
            5'd13: out = data[13];
            5'd14: out = data[14];
            5'd15: out = data[15];
            5'd16: out = data[16];
            5'd17: out = data[17];
            5'd18: out = data[18];
            5'd19: out = data[19];
            5'd20: out = data[20];
            5'd21: out = data[21];
            5'd22: out = data[22];
            5'd23: out = data[23];
            5'd24: out = data[24];
            5'd25: out = data[25];
            5'd26: out = data[26];
            5'd27: out = data[27];
            5'd28: out = data[28];
            5'd29: out = data[29];
            5'd30: out = data[30];
            5'd31: out = data[31];
            default: out = 1'b0; // Default case
        endcase
    end
endmodule