module quicksort (
    input [15:0] unsorted, // 4 elements, 4 bits each
    output [15:0] sorted
);
    wire [3:0] arr [3:0];
    
    // Break the input into an array
    assign arr[0] = unsorted[3:0];
    assign arr[1] = unsorted[7:4];
    assign arr[2] = unsorted[11:8];
    assign arr[3] = unsorted[15:12];

    // Simple sorting logic (bubble sort for simplicity)
    wire [3:0] temp;
    assign sorted[3:0] = (arr[0] < arr[1]) ? arr[0] : arr[1];
    assign sorted[7:4] = (arr[0] < arr[1]) ? arr[1] : arr[0];
    assign sorted[11:8] = (arr[2] < arr[3]) ? arr[2] : arr[3];
    assign sorted[15:12] = (arr[2] < arr[3]) ? arr[3] : arr[2];

    // Final output sorting
    wire [3:0] min1, min2, max1, max2;
    assign min1 = (sorted[3:0] < sorted[7:4]) ? sorted[3:0] : sorted[7:4];
    assign max1 = (sorted[3:0] < sorted[7:4]) ? sorted[7:4] : sorted[3:0];
    assign min2 = (sorted[11:8] < sorted[15:12]) ? sorted[11:8] : sorted[15:12];
    assign max2 = (sorted[11:8] < sorted[15:12]) ? sorted[15:12] : sorted[11:8];

    assign sorted[3:0] = min1;
    assign sorted[7:4] = max1 < min2 ? max1 : min2;
    assign sorted[11:8] = max1 < min2 ? min2 : max1;
    assign sorted[15:12] = max2;

endmodule