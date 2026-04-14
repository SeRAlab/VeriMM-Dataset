module shift_register(
    input               clk     , 
    input               rst     ,
    input               en      ,
    input               load    ,
    input       [3:0]   data_in ,

    output reg  [3:0]   data_out
);

always @(posedge clk) begin
    if (rst) begin
        data_out <= 0;
    end else if (load) begin
        data_out <= data_in;
    end else if (en) begin
        data_out <= {1'b0, data_out[3:1]};
    end
end

endmodule