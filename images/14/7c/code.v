module KNN (
    input [2:0] in_data,
    output reg [1:0] class_label
);
    reg [2:0] training_data [0:4]; // 5 training examples
    reg [1:0] class_labels [0:4]; // Corresponding class labels
    integer i;
    integer min_distance;
    integer distance;
    integer closest_index;

    initial begin
        // Initialize training data and class labels
        training_data[0] = 3'b000; class_labels[0] = 2'b00;
        training_data[1] = 3'b001; class_labels[1] = 2'b01;
        training_data[2] = 3'b010; class_labels[2] = 2'b10;
        training_data[3] = 3'b011; class_labels[3] = 2'b11;
        training_data[4] = 3'b100; class_labels[4] = 2'b00;
    end

    always @(*) begin
        min_distance = 4; // Maximum distance for 3-bit input
        closest_index = 0;
        for (i = 0; i < 5; i = i + 1) begin
            distance = (in_data ^ training_data[i]);
            if (distance < min_distance) begin
                min_distance = distance;
                closest_index = i;
            end
        end
        class_label = class_labels[closest_index];
    end
endmodule