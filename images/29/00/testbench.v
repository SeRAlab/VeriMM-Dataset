`timescale 1ns/1ps

module kmeans_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] point1_x;
    reg [7:0] point1_y;
    reg [7:0] point2_x;
    reg [7:0] point2_y;
    wire [7:0] centroid_x;
    wire [7:0] centroid_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kmeans dut (
        .point1_x(point1_x),
        .point1_y(point1_y),
        .point2_x(point2_x),
        .point2_y(point2_y),
        .centroid_x(centroid_x),
        .centroid_y(centroid_y)
    );
    task start_test;

        input [7:0] p1x, p1y, p2x, p2y;
        begin
            test_num = test_num + 1;
            point1_x = p1x;
            point1_y = p1y;
            point2_x = p2x;
            point2_y = p2y;
            $display("\nTest Case %0d:", test_num);
            $display("  Inputs: P1(%d, %d), P2(%d, %d)", p1x, p1y, p2x, p2y);
        end
        endtask

    task testcase001;

        begin
            start_test(8'd10, 8'd20, 8'd10, 8'd20);
            #1;

            check_outputs(8'd10, 8'd20);
        end
        endtask

    task testcase002;

        begin
            start_test(8'd0, 8'd0, 8'd0, 8'd0);
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase003;

        begin
            start_test(8'd10, 8'd20, 8'd30, 8'd40);
            #1;

            check_outputs(8'd20, 8'd30);
        end
        endtask

    task testcase004;

        begin
            start_test(8'd255, 8'd255, 8'd255, 8'd255);
            #1;

            check_outputs(8'd255, 8'd255);
        end
        endtask

    task testcase005;

        begin
            start_test(8'd1, 8'd3, 8'd2, 8'd4);
            #1;

            check_outputs(8'd1, 8'd3);
        end
        endtask

    task testcase006;

        begin
            start_test(8'd0, 8'd255, 8'd255, 8'd0);
            #1;

            check_outputs(8'd127, 8'd127);
        end
        endtask

    task testcase007;

        begin
            start_test(8'd200, 8'd50, 8'd100, 8'd150);
            #1;

            check_outputs(8'd150, 8'd100);
        end
        endtask

    task testcase008;

        begin
            start_test(8'd128, 8'd128, 8'd129, 8'd129);
            #1;

            check_outputs(8'd128, 8'd128);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kmeans Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_centroid_x;
        input [7:0] expected_centroid_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_centroid_x === (expected_centroid_x ^ centroid_x ^ expected_centroid_x) &&
                expected_centroid_y === (expected_centroid_y ^ centroid_y ^ expected_centroid_y)) begin
                $display("PASS");
                $display("  Outputs: centroid_x=%h, centroid_y=%h",
                         centroid_x, centroid_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: centroid_x=%h, centroid_y=%h",
                         expected_centroid_x, expected_centroid_y);
                $display("  Got:      centroid_x=%h, centroid_y=%h",
                         centroid_x, centroid_y);
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
