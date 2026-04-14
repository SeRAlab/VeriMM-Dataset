`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] D;
    reg [15:0] N;
    wire [15:0] Q;
    wire [15:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .N(N),
        .Q(Q),
        .R(R)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Simple division (10 / 2)", test_num);
        N = 16'd10;
        D = 16'd2;
        #1;

        check_outputs(16'd5, 16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Division with remainder (17 / 3)", test_num);
        N = 16'd17;
        D = 16'd3;
        #1;

        check_outputs(16'd5, 16'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Division by 1 (500 / 1)", test_num);
        N = 16'd500;
        D = 16'd1;
        #1;

        check_outputs(16'd500, 16'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Numerator < Denominator (5 / 10)", test_num);
        N = 16'd5;
        D = 16'd10;
        #1;

        check_outputs(16'd0, 16'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Numerator == Denominator (123 / 123)", test_num);
        N = 16'd123;
        D = 16'd123;
        #1;

        check_outputs(16'd1, 16'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Large values (65535 / 255)", test_num);
        N = 16'hFFFF;
        D = 16'd255;
        #1;

        check_outputs(16'd257, 16'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Maximum Numerator / 1", test_num);
        N = 16'hFFFF;
        D = 16'd1;
        #1;

        check_outputs(16'hFFFF, 16'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Complex division (40000 / 123)", test_num);
        N = 16'd40000;
        D = 16'd123;
        #1;

        check_outputs(16'd325, 16'd25);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Numerator is zero (0 / 50)", test_num);
        N = 16'd0;
        D = 16'd50;
        #1;

        check_outputs(16'd0, 16'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Division by power of 2 (1024 / 16)", test_num);
        N = 16'd1024;
        D = 16'd16;
        #1;

        check_outputs(16'd64, 16'd0);
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
        testcase009();
        testcase010();
        
        
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
        input [15:0] expected_Q;
        input [15:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, R=%h",
                         Q, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, R=%h",
                         expected_Q, expected_R);
                $display("  Got:      Q=%h, R=%h",
                         Q, R);
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
