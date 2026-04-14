`timescale 1ns/1ps

module knn_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] point1_x;
    reg [3:0] point1_y;
    reg [3:0] point2_x;
    reg [3:0] point2_y;
    reg [3:0] point3_x;
    reg [3:0] point3_y;
    reg [3:0] point4_x;
    reg [3:0] point4_y;
    reg [3:0] target_x;
    reg [3:0] target_y;
    wire [1:0] nearest_index;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    knn dut (
        .point1_x(point1_x),
        .point1_y(point1_y),
        .point2_x(point2_x),
        .point2_y(point2_y),
        .point3_x(point3_x),
        .point3_y(point3_y),
        .point4_x(point4_x),
        .point4_y(point4_y),
        .target_x(target_x),
        .target_y(target_y),
        .nearest_index(nearest_index)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Target is exactly Point 1", test_num);
            point1_x = 4'd2;  point1_y = 4'd2;
            point2_x = 4'd10; point2_y = 4'd10;
            point3_x = 4'd15; point3_y = 4'd0;
            point4_x = 4'd0;  point4_y = 4'd15;
            target_x = 4'd2;  target_y = 4'd2;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Target is exactly Point 3", test_num);
            point1_x = 4'd1;  point1_y = 4'd1;
            point2_x = 4'd8;  point2_y = 4'd8;
            point3_x = 4'd5;  point3_y = 4'd5;
            point4_x = 4'd12; point4_y = 4'd12;
            target_x = 4'd5;  target_y = 4'd5;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Target closest to Point 2 (Near-match)", test_num);
            point1_x = 4'd0;  point1_y = 4'd0;
            point2_x = 4'd3;  point2_y = 4'd3;
            point3_x = 4'd8;  point3_y = 4'd8;
            point4_x = 4'd15; point4_y = 4'd15;
            target_x = 4'd4;  target_y = 4'd4;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Extreme far target, Point 4 is closest", test_num);
            point1_x = 4'd0;  point1_y = 4'd0;
            point2_x = 4'd1;  point2_y = 4'd1;
            point3_x = 4'd2;  point3_y = 4'd2;
            point4_x = 4'd10; point4_y = 4'd10;
            target_x = 4'd15; target_y = 4'd15;
            #1;

            check_outputs(2'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Tie-break check (P1 and P2 equidistant)", test_num);
            point1_x = 4'd6;  point1_y = 4'd6;
            point2_x = 4'd8;  point2_y = 4'd8;
            point3_x = 4'd0;  point3_y = 4'd0;
            point4_x = 4'd15; point4_y = 4'd15;
            target_x = 4'd7;  target_y = 4'd7;

            #1;


            check_outputs(2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Target at origin (0,0)", test_num);
            point1_x = 4'd15; point1_y = 4'd15;
            point2_x = 4'd10; point2_y = 4'd5;
            point3_x = 4'd2;  point3_y = 4'd3;
            point4_x = 4'd4;  point4_y = 4'd1;
            target_x = 4'd0;  target_y = 4'd0;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum coordinate range (15,15)", test_num);
            point1_x = 4'd15; point1_y = 4'd15;
            point2_x = 4'd0;  point2_y = 4'd0;
            point3_x = 4'd15; point3_y = 4'd0;
            point4_x = 4'd0;  point4_y = 4'd15;
            target_x = 4'd14; target_y = 4'd14;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Specific distance comparison", test_num);
            point1_x = 4'd0;  point1_y = 4'd2;
            point2_x = 4'd5;  point2_y = 4'd1;
            point3_x = 4'd10; point3_y = 4'd10;
            point4_x = 4'd15; point4_y = 4'd15;
            target_x = 4'd3;  target_y = 4'd0;
            #1;

            check_outputs(2'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("knn Testbench");
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
        input [1:0] expected_nearest_index;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nearest_index === (expected_nearest_index ^ nearest_index ^ expected_nearest_index)) begin
                $display("PASS");
                $display("  Outputs: nearest_index=%h",
                         nearest_index);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nearest_index=%h",
                         expected_nearest_index);
                $display("  Got:      nearest_index=%h",
                         nearest_index);
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
