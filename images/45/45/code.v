module top_module(
    clock0,
    ena0,
    dataa,
    datab,
    result
);parameter REPRESENTATION = "UNSIGNED";

input clock0;
input ena0;
input [26:0] dataa;
input [26:0] datab;
output [53:0] result;

reg [26:0] dataa_reg;
reg [26:0] datab_reg;

reg [53:0] mult_result;
reg [53:0] add_result;

always @(posedge clock0) begin
    if(ena0 == 1) begin
        dataa_reg <= dataa;
        datab_reg <= datab;
        if(REPRESENTATION == "UNSIGNED") begin
            mult_result <= dataa_reg * datab_reg;
            add_result <= {54'b0, mult_result} + {54'b0, mult_result};
        end else begin
            mult_result <= $signed(dataa_reg) * $signed(datab_reg);
            add_result <= {54'b0, $signed(mult_result)} + {54'b0, $signed(mult_result)};
        end
    end
end

assign result = add_result;

endmodule