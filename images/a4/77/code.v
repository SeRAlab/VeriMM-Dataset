module top_module(clk, d, q);(* keep_hierarchy = "true" *)
    (* equivalent_register_removal = "no" *)
    (* shift_extract = "no" *)
    (* shreg_extract = "no" *)
    input clk;
    input [4:0] d;
    output [4:0] q;
    reg [4:0] q_reg;
    
    always @(posedge clk) begin
        q_reg <= d;
    end
    
    assign q = q_reg;
endmodule