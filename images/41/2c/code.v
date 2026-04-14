module top_module(
    input [3:0] data_in,
    input shift_en,
    input load_en,
    output reg [3:0] data_out
);always @ (posedge shift_en or posedge load_en)
    begin
        if (load_en)
            data_out <= data_in;
        else if (shift_en)
            data_out <= {data_out[2:0], data_out[3]};
    end

endmodule