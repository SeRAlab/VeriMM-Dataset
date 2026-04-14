`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg div;
    wire [15:0] high;
    wire [15:0] low;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .div(div),
        .high(high),
        .low(low)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple division (20 / 5)", test_num);
            A = 16'd20;
            B = 16'd5;
            div = 1'b1;
            #10;
            #1;

            check_outputs(16'd4, 16'd0);
            div = 1'b0;
            #5;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Division with remainder (17 / 3)", test_num);
            A = 16'd17;
            B = 16'd3;
            div = 1'b1;
            #10;
            #1;

            check_outputs(16'd5, 16'd2);
            div = 1'b0;
            #5;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A < B (5 / 12)", test_num);
            A = 16'd5;
            B = 16'd12;
            div = 1'b1;
            #10;
            #1;

            check_outputs(16'd0, 16'd5);
            div = 1'b0;
            #5;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A == B (1024 / 1024)", test_num);
            A = 16'd1024;
            B = 16'd1024;
            div = 1'b1;
            #10;
            #1;

            check_outputs(16'd1, 16'd0);
            div = 1'b0;
            #5;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max dividend / 1", test_num);
            A = 16'hFFFF;
            B = 16'd1;
            div = 1'b1;
            #10;
            #1;

            check_outputs(16'hFFFF, 16'd0);
            div = 1'b0;
            #5;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max dividend / 256", test_num);
            A = 16'hFFFF;
            B = 16'd256;
            div = 1'b1;
            #10;
            #1;

            check_outputs(16'd255, 16'd255);
            div = 1'b0;
            #5;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dividend is zero (0 / 50)", test_num);
            A = 16'd0;
            B = 16'd50;
            div = 1'b1;
            #10;
            #1;

            check_outputs(16'd0, 16'd0);
            div = 1'b0;
            #5;
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large values (40000 / 7)", test_num);
            A = 16'd40000;
            B = 16'd7;
            div = 1'b1;
            #10;
            #1;

            check_outputs(16'd5714, 16'd2);
            div = 1'b0;
            #5;
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
        input [15:0] expected_high;
        input [15:0] expected_low;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_high === (expected_high ^ high ^ expected_high) &&
                expected_low === (expected_low ^ low ^ expected_low)) begin
                $display("PASS");
                $display("  Outputs: high=%h, low=%h",
                         high, low);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: high=%h, low=%h",
                         expected_high, expected_low);
                $display("  Got:      high=%h, low=%h",
                         high, low);
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
