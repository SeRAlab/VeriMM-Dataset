`timescale 1ns/1ps

module knn_distance_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] point1_x;
    reg [15:0] point1_y;
    reg [15:0] point1_z;
    reg [15:0] point2_x;
    reg [15:0] point2_y;
    reg [15:0] point2_z;
    reg [15:0] point3_x;
    reg [15:0] point3_y;
    reg [15:0] point3_z;
    reg [15:0] query_x;
    reg [15:0] query_y;
    reg [15:0] query_z;
    wire [31:0] distance1;
    wire [31:0] distance2;
    wire [31:0] distance3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    knn_distance dut (
        .point1_x(point1_x),
        .point1_y(point1_y),
        .point1_z(point1_z),
        .point2_x(point2_x),
        .point2_y(point2_y),
        .point2_z(point2_z),
        .point3_x(point3_x),
        .point3_y(point3_y),
        .point3_z(point3_z),
        .query_x(query_x),
        .query_y(query_y),
        .query_z(query_z),
        .distance1(distance1),
        .distance2(distance2),
        .distance3(distance3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            point1_x = 16'd0; point1_y = 16'd0; point1_z = 16'd0;
            point2_x = 16'd0; point2_y = 16'd0; point2_z = 16'd0;
            point3_x = 16'd0; point3_y = 16'd0; point3_z = 16'd0;
            query_x  = 16'd0; query_y  = 16'd0; query_z  = 16'd0;


            #1;



            check_outputs(32'd0, 32'd0, 32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Unit Distances (Squared)", test_num);

            query_x  = 16'd0; query_y  = 16'd0; query_z  = 16'd0;

            point1_x = 16'd1; point1_y = 16'd0; point1_z = 16'd0;

            point2_x = 16'd0; point2_y = 16'd2; point2_z = 16'd0;

            point3_x = 16'd0; point3_y = 16'd0; point3_z = 16'd3;

            #1;


            check_outputs(32'd1, 32'd4, 32'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mixed Coordinates and Exact Match", test_num);

            query_x  = 16'd10; query_y  = 16'd20; query_z  = 16'd30;


            point1_x = 16'd10; point1_y = 16'd20; point1_z = 16'd30;


            point2_x = 16'd12; point2_y = 16'd22; point2_z = 16'd32;


            point3_x = 16'd10; point3_y = 16'd20; point3_z = 16'd40;

            #1;


            check_outputs(32'h0, 32'hC, 32'h64);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative Coordinates (2's Complement)", test_num);


            query_x  = 16'hFFFF; query_y  = 16'hFFFF; query_z  = 16'hFFFF;


            point1_x = 16'h0000; point1_y = 16'h0000; point1_z = 16'h0000;


            point2_x = 16'h0001; point2_y = 16'h0001; point2_z = 16'h0001;


            point3_x = 16'hFFFE; point3_y = 16'hFFFE; point3_z = 16'hFFFE;

            #1;


            check_outputs(32'd3, 32'd12, 32'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Larger Distance Calculation", test_num);

            query_x  = 16'd0;    query_y  = 16'd0;    query_z  = 16'd0;


            point1_x = 16'd100;  point1_y = 16'd100;  point1_z = 16'd100;


            point2_x = 16'd255;  point2_y = 16'd0;    point2_z = 16'd0;


            point3_x = 16'd50;   point3_y = 16'd60;   point3_z = 16'd70;

            #1;


            check_outputs(32'd30000, 32'd65025, 32'd11000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("knn_distance Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [31:0] expected_distance1;
        input [31:0] expected_distance2;
        input [31:0] expected_distance3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_distance1 === (expected_distance1 ^ distance1 ^ expected_distance1) &&
                expected_distance2 === (expected_distance2 ^ distance2 ^ expected_distance2) &&
                expected_distance3 === (expected_distance3 ^ distance3 ^ expected_distance3)) begin
                $display("PASS");
                $display("  Outputs: distance1=%h, distance2=%h, distance3=%h",
                         distance1, distance2, distance3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: distance1=%h, distance2=%h, distance3=%h",
                         expected_distance1, expected_distance2, expected_distance3);
                $display("  Got:      distance1=%h, distance2=%h, distance3=%h",
                         distance1, distance2, distance3);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
