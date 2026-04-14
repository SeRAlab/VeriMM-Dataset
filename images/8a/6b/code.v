module shift_register (
    input        clk,
    input        rst,
    input        load,
    input  [3:0] data_in,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (rst) begin
            q <= 4'b0000;
        end else if (load) begin
            q <= data_in;
        end else begin
            q <= {1'b0, q[3:1]};
        end
    end
    
endmodule