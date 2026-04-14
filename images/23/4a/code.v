module heap_sort(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    output reg [3:0] sorted_0,
    output reg [3:0] sorted_1,
    output reg [3:0] sorted_2,
    output reg [3:0] sorted_3
);

reg [3:0] arr [0:3];
integer i;

always @(*) begin
    // Load inputs into an array
    arr[0] = a;
    arr[1] = b;
    arr[2] = c;
    arr[3] = d;

    // Simple Heap Sort implementation
    for (i = 0; i < 4; i = i + 1) begin
        if (arr[i] > arr[(i-1)/2]) begin
            // Swap logic
            {arr[i], arr[(i-1)/2]} = {arr[(i-1)/2], arr[i]};
        end
    end

    // Output sorted values
    sorted_0 = arr[0];
    sorted_1 = arr[1];
    sorted_2 = arr[2];
    sorted_3 = arr[3];
end

endmodule