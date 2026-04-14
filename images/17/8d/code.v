module fixed_priority_arbiter(
    input clk,
    input rst_n,
    input [3:0] req,
    output reg [3:0] grant
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            grant <= 4'b0000;
        end else begin
            casez (req)
                4'b1??? : grant <= 4'b0001; // req[0] has highest priority
                4'b01?? : grant <= 4'b0010; // req[1] has second highest priority
                4'b001? : grant <= 4'b0100; // req[2]
                4'b0001 : grant <= 4'b1000; // req[3]
                default : grant <= 4'b0000; // no request
            endcase
        end
    end
endmodule