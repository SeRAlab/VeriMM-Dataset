module top_module(
    input wire clk,
    input wire [5:0] addr,
    output wire [23:0] data);reg [23:0] data_ff;
assign data = data_ff;
always @(posedge clk) begin
    case(addr)
        0: data_ff <= 24'hF55B94; 
        1: data_ff <= 24'h0A4478; 
        2: data_ff <= 24'hFE1404; 
        3: data_ff <= 24'hFD27DD; 
        4: data_ff <= 24'h023120; 
        5: data_ff <= 24'h001A34; 
        6: data_ff <= 24'hFF135A; 
        7: data_ff <= 24'h0062C9; 
        8: data_ff <= 24'h0025B8; 
        9: data_ff <= 24'hFFD29C; 
        10: data_ff <= 24'h000730; 
        11: data_ff <= 24'h000771; 
        12: data_ff <= 24'hFFFC96; 
        13: data_ff <= 24'hFFFFED; 
        14: data_ff <= 24'h000039; 
        15: data_ff <= 24'hFFFFFD; 
        16: data_ff <= 24'h21AF3A; 
        17: data_ff <= 24'h02844A; 
        18: data_ff <= 24'hF9134D; 
        19: data_ff <= 24'h027000; 
        20: data_ff <= 24'h019209; 
        21: data_ff <= 24'hFE3718; 
        22: data_ff <= 24'h003947; 
        23: data_ff <= 24'h009481; 
        24: data_ff <= 24'hFFA9E0; 
        25: data_ff <= 24'hFFF4F8; 
        26: data_ff <= 24'h001C13; 
        27: data_ff <= 24'hFFF8B0; 
        28: data_ff <= 24'hFFFD09; 
        29: data_ff <= 24'h0001C5; 
        30: data_ff <= 24'hFFFFEB; 
        31: data_ff <= 24'hFFFFF8; 
        32: data_ff <= 24'h508A9C; 
        33: data_ff <= 24'hEFF89B; 
        34: data_ff <= 24'h008D60; 
        35: data_ff <= 24'h04948A; 
        36: data_ff <= 24'hFD8AD9; 
        37: data_ff <= 24'hFF5250; 
        38: data_ff <= 24'h0156D9; 
        39: data_ff <= 24'hFFA255; 
        40: data_ff <= 24'hFFAD9C; 
        41: data_ff <= 24'h004204; 
        42: data_ff <= 24'hFFFDA1; 
        43: data_ff <= 24'hFFF084; 
        44: data_ff <= 24'h000583; 
        45: data_ff <= 24'h0000DA; 
        46: data_ff <= 24'hFFFF43; 
        47: data_ff <= 24'h00000C; 

        default: data_ff <= 0;
    endcase
end
endmodule