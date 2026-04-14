module top_module(input wire pb_clk_debounced,
            input wire rst_general,
            input wire [7:0] immediate, 
            input wire [7:0] take_branch,
            output reg [7:0] pc);always @(posedge pb_clk_debounced or posedge rst_general) begin
    if(rst_general)
        pc <= 8'b00000000;
    else 
        if(pb_clk_debounced)
            if(take_branch)
                pc <= pc+immediate;
            else 
                pc <= pc+1; 
 end
endmodule