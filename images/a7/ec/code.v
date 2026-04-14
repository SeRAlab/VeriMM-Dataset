module top_module(
    input wire[3:0] value,
    input wire auxValue,
    output reg[6:0] segments
    );always @ (*) begin
    if (auxValue) begin
        case (value)
            4'h0: segments = 7'h00; 
            4'h1: segments = 7'h73; 
            4'h2: segments = 7'h78; 
            4'h3: segments = 7'h50; 
            4'h4: segments = 7'h1C; 
            4'h5: segments = 7'h76; 
            4'h6: segments = 7'h38; 
            default: segments = 7'b0;
        endcase
    end
    else begin 
        case (value)
            4'h0: segments = 7'h3F; 
            4'h1: segments = 7'h06; 
            4'h2: segments = 7'h5B; 
            4'h3: segments = 7'h4F; 
            4'h4: segments = 7'h66; 
            4'h5: segments = 7'h6D; 
            4'h6: segments = 7'h7D; 
            4'h7: segments = 7'h07; 
            4'h8: segments = 7'h7F; 
            4'h9: segments = 7'h6F; 
            4'hA: segments = 7'h77; 
            4'hB: segments = 7'h7C; 
            4'hC: segments = 7'h39; 
            4'hD: segments = 7'h5E; 
            4'hE: segments = 7'h79; 
            4'hF: segments = 7'h71; 
            default: segments = 7'b0;
        endcase
    end
end
endmodule