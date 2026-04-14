module top_module(
    input [3:0] a,
    input [3:0] b,
    output reg [7:0] result
);reg [7:0] temp;
    reg [3:0] i, j;
    
    always @(*) begin
        temp = 8'b0;
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                if ((a[i] == 1) && (b[j] == 1)) begin
                    temp[i+j] = temp[i+j] + 1;
                end
            end
        end
        
        for (i = 0; i < 7; i = i + 1) begin
            if (temp[i] == 2) begin
                temp[i] = 0;
                temp[i+1] = temp[i+1] + 1;
            end
        end
    end
    
    assign result = temp;
    
endmodule