module top_module(
    output reg [7:0] dbr,   
    input  [7:0] addr,  
    input  clk          
    );reg [7:0] rom_data[0:255];

    always @(posedge clk)
        dbr <= rom_data[addr];

endmodule