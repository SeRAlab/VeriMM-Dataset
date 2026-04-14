module top_module(input wire clock, 
            input wire reset);reg [31:0] pc = 0;

  always @(posedge clock) 
    if (reset) begin
        pc = 0;
    end else begin
        pc = pc + 1;
    end 

endmodule