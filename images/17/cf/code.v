module bubble_sort(
    input [19:0] data_in, // 5 numbers, 4 bits each
    output [19:0] data_out // sorted output
);
    wire [3:0] a [0:4];
    assign a[0] = data_in[19:16];
    assign a[1] = data_in[15:12];
    assign a[2] = data_in[11:8];
    assign a[3] = data_in[7:4];
    assign a[4] = data_in[3:0];

    wire [3:0] sorted [0:4];
    
    // Bubble Sort Logic
    genvar i, j;
    generate
        for(i = 0; i < 5; i = i + 1) begin : outer_loop
            for(j = 0; j < 4 - i; j = j + 1) begin : inner_loop
                assign sorted[j] = (a[j] < a[j + 1]) ? a[j] : a[j + 1];
                assign sorted[j + 1] = (a[j] < a[j + 1]) ? a[j + 1] : a[j];
            end
        end
    endgenerate

    assign data_out = {sorted[4], sorted[3], sorted[2], sorted[1], sorted[0]};
endmodule