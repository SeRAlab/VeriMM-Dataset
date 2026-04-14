module top_module(
    clock,
    dataa,
    datab,
    result
);input   clock;
input   [11:0]  dataa;
input   [7:0]   datab;
output  [19:0]  result;

reg     [19:0]  temp_result;

always @ (posedge clock) begin
    temp_result <= {dataa, 8'b0} * {8'b0, datab};
end

assign result = temp_result;

endmodule