module top_module(
    input logic start,
    output logic [31:0] out
);logic [31:0] count;

    always_ff @(posedge start) begin
        if (count < 10) begin
            count <= count + 1;
        end
    end

    always_comb begin
        out = count;
    end

endmodule