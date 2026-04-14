`timescale 1ns/1ps

module hough_transform_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] pixel;
    wire [7:0] angle;
    wire [7:0] distance;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hough_transform dut (
        .pixel(pixel),
        .angle(angle),
        .distance(distance)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Background Pixel", test_num);
            pixel = 4'b0000;

            #1;


            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge Pixel Value 1", test_num);
            pixel = 4'b0001;

            #1;


            check_outputs(8'd45, 8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge Pixel Value 5", test_num);
            pixel = 4'b0101;

            #1;


            check_outputs(8'd90, 8'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge Pixel Value 10", test_num);
            pixel = 4'b1010;

            #1;


            check_outputs(8'd135, 8'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Pixel Value (15)", test_num);
            pixel = 4'b1111;

            #1;


            check_outputs(8'd180, 8'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rapid Transition (8 to 0)", test_num);
            pixel = 4'b1000;
            #5;
            pixel = 4'b0000;
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hough_transform Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_angle;
        input [7:0] expected_distance;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_angle === (expected_angle ^ angle ^ expected_angle) &&
                expected_distance === (expected_distance ^ distance ^ expected_distance)) begin
                $display("PASS");
                $display("  Outputs: angle=%h, distance=%h",
                         angle, distance);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: angle=%h, distance=%h",
                         expected_angle, expected_distance);
                $display("  Got:      angle=%h, distance=%h",
                         angle, distance);
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
