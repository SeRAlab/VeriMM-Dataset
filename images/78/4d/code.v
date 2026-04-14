module binary_up_counter(
    input                 clk, 
    input                 rst,
    input                 enable,
    output   reg [3:0]    count,
    output   reg          done
);

// Counting logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 4'd0;
    end else if (enable) begin
        if (count == 4'd15) begin
            count <= 4'd0;
        end else begin
            count <= count + 1;
        end
    end
end

// Done signal logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        done <= 1'b0;
    end else if (enable && count == 4'd15) begin
        done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
end

endmodule