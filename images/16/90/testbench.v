`timescale 1ns/1ps

module kmeans_selector_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] centroid_x;
    reg [7:0] centroid_y;
    reg [7:0] point1_x;
    reg [7:0] point1_y;
    reg [7:0] point2_x;
    reg [7:0] point2_y;
    wire [1:0] closest_point;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kmeans_selector dut (
        .centroid_x(centroid_x),
        .centroid_y(centroid_y),
        .point1_x(point1_x),
        .point1_y(point1_y),
        .point2_x(point2_x),
        .point2_y(point2_y),
        .closest_point(closest_point)
    );
    task set_inputs;

        input [7:0] cx, cy, p1x, p1y, p2x, p2y;
        begin
            centroid_x = cx;
            centroid_y = cy;
            point1_x = p1x;
            point1_y = p1y;
            point2_x = p2x;
            point2_y = p2y;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Point 1 is closer", test_num);
            set_inputs(8'd10, 8'd10, 8'd12, 8'd12, 8'd50, 8'd50);
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Point 2 is closer", test_num);
            set_inputs(8'd100, 8'd100, 8'd0, 8'd0, 8'd101, 8'd101);
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Point 1 matches centroid exactly", test_num);
            set_inputs(8'd50, 8'd50, 8'd50, 8'd50, 8'd55, 8'd55);
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Point 2 matches centroid exactly", test_num);
            set_inputs(8'd128, 8'd128, 8'd100, 8'd100, 8'd128, 8'd128);
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Tie condition (equidistant points)", test_num);
            set_inputs(8'd10, 8'd10, 8'd11, 8'd10, 8'd9, 8'd10);
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large coordinates", test_num);
            set_inputs(8'd255, 8'd255, 8'd250, 8'd250, 8'd10, 8'd10);
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Vertical distance comparison", test_num);
            set_inputs(8'd100, 8'd100, 8'd100, 8'd110, 8'd100, 8'd105);
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtle distance difference", test_num);


            set_inputs(8'd20, 8'd20, 8'd23, 8'd23, 8'd24, 8'd21);
            #1;

            check_outputs(2'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kmeans_selector Testbench");
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
        input [1:0] expected_closest_point;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_closest_point === (expected_closest_point ^ closest_point ^ expected_closest_point)) begin
                $display("PASS");
                $display("  Outputs: closest_point=%h",
                         closest_point);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: closest_point=%h",
                         expected_closest_point);
                $display("  Got:      closest_point=%h",
                         closest_point);
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
