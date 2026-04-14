module top_module(
    output reg [7:0] q,
    input [7:0] d,
    input [18:0] write_address, read_address,
    input we, clk
);(* ramstyle = "M10K" *)
    
    reg [7:0] mem [383999:0] ;
    
    always @ (posedge clk) begin
        if (we)
            mem[write_address] <= d;
        q <= mem[read_address]; 
    end
    
endmodule