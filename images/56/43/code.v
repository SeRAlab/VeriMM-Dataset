module top_module(
    input wire clk,
    input wire [3:0] addr,
    output wire [23:0] data);reg [23:0] data_ff;
assign data = data_ff;
always @(posedge clk) begin
    case(addr)
        0: data_ff <= 24'h16B4E1; 
        1: data_ff <= 24'h050C70; 
        2: data_ff <= 24'hFD6D3E; 
        3: data_ff <= 24'hFEFCB7; 
        4: data_ff <= 24'h003573; 
        5: data_ff <= 24'h0013DD; 
        6: data_ff <= 24'hFFFF42; 
        7: data_ff <= 24'hFFFFF6; 
        8: data_ff <= 24'h1C8992; 
        9: data_ff <= 24'h0DAAE0; 
        10: data_ff <= 24'hFF750F; 
        11: data_ff <= 24'hFDCF4A; 
        12: data_ff <= 24'hFFE0FC; 
        13: data_ff <= 24'h002F67; 
        14: data_ff <= 24'h00036F; 
        15: data_ff <= 24'hFFFF93; 

        default: data_ff <= 0;
    endcase
end
endmodule