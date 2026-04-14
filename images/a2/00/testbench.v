`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg [10:0] Q;
    reg [10:0] Q_reg;
    wire [23:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .Q(Q),
        .Q_reg(Q_reg),
        .P(P)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: 0 * 0", test_num);


        Q = 11'd0;
        Q_reg = 11'd0;
        repeat(15) @(posedge CLK);
        #1;

        check_outputs(24'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Max * Max", test_num);
        Q = 11'd2047;
        Q_reg = 11'd2047;
        repeat(15) @(posedge CLK);
        #1;

        check_outputs(24'd4190209);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: 123 * 1", test_num);
        Q = 11'd123;
        Q_reg = 11'd1;
        repeat(15) @(posedge CLK);
        #1;

        check_outputs(24'd123);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: 123 * 456", test_num);
        Q = 11'd123;
        Q_reg = 11'd456;
        repeat(15) @(posedge CLK);
        #1;

        check_outputs(24'd56088);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: 512 * 8", test_num);
        Q = 11'd512;
        Q_reg = 11'd8;
        repeat(15) @(posedge CLK);
        #1;

        check_outputs(24'd4096);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: 101 * 19", test_num);
        Q = 11'd101;
        Q_reg = 11'd19;
        repeat(15) @(posedge CLK);
        #1;

        check_outputs(24'd1919);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: 2047 * 0", test_num);
        Q = 11'd2047;
        Q_reg = 11'd0;
        repeat(15) @(posedge CLK);
        #1;

        check_outputs(24'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: 15 * 15", test_num);
        Q = 11'd15;
        Q_reg = 11'd15;
        repeat(15) @(posedge CLK);
        #1;

        check_outputs(24'd225);
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
        input [23:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
