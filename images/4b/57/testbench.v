`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] y1;
    reg [15:0] y2;
    reg [15:0] z1;
    reg [15:0] z2;
    wire [15:0] left_x;
    wire [15:0] left_y;
    wire [15:0] left_z;
    wire [15:0] right_x;
    wire [15:0] right_y;
    wire [15:0] right_z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .z1(z1),
        .z2(z2),
        .left_x(left_x),
        .left_y(left_y),
        .left_z(left_z),
        .right_x(right_x),
        .right_y(right_y),
        .right_z(right_z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x1 < x2 (Simple ascending order)", test_num);
            x1 = 16'h000A; y1 = 16'h0001; z1 = 16'h0001;
            x2 = 16'h0014; y2 = 16'h0002; z2 = 16'h0002;

            #1;


            check_outputs(16'h000A, 16'h0001, 16'h0001, 16'h0014, 16'h0002, 16'h0002);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x1 > x2 (Simple swap needed)", test_num);
            x1 = 16'h0100; y1 = 16'hAAAA; z1 = 16'hBBBB;
            x2 = 16'h0050; y2 = 16'hCCCC; z2 = 16'hDDDD;

            #1;


            check_outputs(16'h0050, 16'hCCCC, 16'hDDDD, 16'h0100, 16'hAAAA, 16'hBBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x1 == x2 (Edge case equality)", test_num);
            x1 = 16'h0500; y1 = 16'h1111; z1 = 16'h2222;
            x2 = 16'h0500; y2 = 16'h3333; z2 = 16'h4444;


            #1;



            check_outputs(16'h0500, 16'h3333, 16'h4444, 16'h0500, 16'h1111, 16'h2222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum vs Minimum unsigned values", test_num);
            x1 = 16'hFFFF; y1 = 16'hFFFF; z1 = 16'hFFFF;
            x2 = 16'h0000; y2 = 16'h0000; z2 = 16'h0000;

            #1;


            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'hFFFF, 16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large x, small y/z vs small x, large y/z", test_num);
            x1 = 16'hF000; y1 = 16'h0001; z1 = 16'h0001;
            x2 = 16'h000F; y2 = 16'hFFFF; z2 = 16'hFFFF;

            #1;


            check_outputs(16'h000F, 16'hFFFF, 16'hFFFF, 16'hF000, 16'h0001, 16'h0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identical Points", test_num);
            x1 = 16'h1234; y1 = 16'h5678; z1 = 16'h9ABC;
            x2 = 16'h1234; y2 = 16'h5678; z2 = 16'h9ABC;

            #1;


            check_outputs(16'h1234, 16'h5678, 16'h9ABC, 16'h1234, 16'h5678, 16'h9ABC);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit difference in x", test_num);
            x1 = 16'h8001; y1 = 16'h1; z1 = 16'h1;
            x2 = 16'h8000; y2 = 16'h2; z2 = 16'h2;

            #1;


            check_outputs(16'h8000, 16'h2, 16'h2, 16'h8001, 16'h1, 16'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_left_x;
        input [15:0] expected_left_y;
        input [15:0] expected_left_z;
        input [15:0] expected_right_x;
        input [15:0] expected_right_y;
        input [15:0] expected_right_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_left_x === (expected_left_x ^ left_x ^ expected_left_x) &&
                expected_left_y === (expected_left_y ^ left_y ^ expected_left_y) &&
                expected_left_z === (expected_left_z ^ left_z ^ expected_left_z) &&
                expected_right_x === (expected_right_x ^ right_x ^ expected_right_x) &&
                expected_right_y === (expected_right_y ^ right_y ^ expected_right_y) &&
                expected_right_z === (expected_right_z ^ right_z ^ expected_right_z)) begin
                $display("PASS");
                $display("  Outputs: left_x=%h, left_y=%h, left_z=%h, right_x=%h, right_y=%h, right_z=%h",
                         left_x, left_y, left_z, right_x, right_y, right_z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: left_x=%h, left_y=%h, left_z=%h, right_x=%h, right_y=%h, right_z=%h",
                         expected_left_x, expected_left_y, expected_left_z, expected_right_x, expected_right_y, expected_right_z);
                $display("  Got:      left_x=%h, left_y=%h, left_z=%h, right_x=%h, right_y=%h, right_z=%h",
                         left_x, left_y, left_z, right_x, right_y, right_z);
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
