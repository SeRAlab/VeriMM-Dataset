module fixed_priority_arbiter (
    input wire [3:0] req,
    input wire reset,
    output reg [3:0] grant
);
    always @(posedge reset or posedge req[0] or posedge req[1] or posedge req[2] or posedge req[3]) begin
        if (reset) begin
            grant <= 4'b0000;
        end else begin
            grant <= 4'b0000; // Default no grant
            if (req[0]) grant <= 4'b0001; // Grant req[0]
            else if (req[1]) grant <= 4'b0010; // Grant req[1]
            else if (req[2]) grant <= 4'b0100; // Grant req[2]
            else if (req[3]) grant <= 4'b1000; // Grant req[3]
        end
    end
endmodule