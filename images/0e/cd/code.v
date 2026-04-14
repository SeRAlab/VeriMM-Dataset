module merge_sort(input [15:0] data_in, output [15:0] data_out);  
    wire [3:0] arr [0:3];  
    wire [3:0] sorted [0:3];  

    assign arr[0] = data_in[15:12];  
    assign arr[1] = data_in[11:8];  
    assign arr[2] = data_in[7:4];  
    assign arr[3] = data_in[3:0];  

    // Sorting logic using simple comparison  
    assign sorted[0] = (arr[0] < arr[1]) ? arr[0] : arr[1];  
    assign sorted[1] = (arr[0] < arr[1]) ? arr[1] : arr[0];  
    assign sorted[2] = (arr[2] < arr[3]) ? arr[2] : arr[3];  
    assign sorted[3] = (arr[2] < arr[3]) ? arr[3] : arr[2];  

    assign data_out = {sorted[3], sorted[2], sorted[1], sorted[0]};  
endmodule