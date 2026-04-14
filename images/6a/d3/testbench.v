`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] q;
    wire [3:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .q(q),
        .r(r)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 8 / 2", test_num);
        a = 4'd8; b = 4'd2;
        #1;

        check_outputs(4'd4, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 7 / 3", test_num);
        a = 4'd7; b = 4'd3;
        #1;

        check_outputs(4'd2, 4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 3 / 10", test_num);
        a = 4'd3; b = 4'd10;
        #1;

        check_outputs(4'd0, 4'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 5 / 0 (Special case)", test_num);
        a = 4'd5; b = 4'd0;
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 0 / 5 (Special case)", test_num);
        a = 4'd0; b = 4'd5;
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 15 / 4", test_num);
        a = 4'd15; b = 4'd4;
        #1;

        check_outputs(4'd3, 4'd3);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 12 / 1", test_num);
        a = 4'd12; b = 4'd1;
        #1;

        check_outputs(4'd12, 4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 9 / 9", test_num);
        a = 4'd9; b = 4'd9;
        #1;

        check_outputs(4'd1, 4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 15 / 15", test_num);
        a = 4'd15; b = 4'd15;
        #1;

        check_outputs(4'd1, 4'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 13 / 2", test_num);
        a = 4'd13; b = 4'd2;
        #1;

        check_outputs(4'd6, 4'd1);
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
        input [3:0] expected_q;
        input [3:0] expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: q=%h, r=%h",
                         q, r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, r=%h",
                         expected_q, expected_r);
                $display("  Got:      q=%h, r=%h",
                         q, r);
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
