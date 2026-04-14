`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg double;
    reg [15:0] md;
    reg negation;
    reg zero;
    wire [16:0] pp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .double(double),
        .md(md),
        .negation(negation),
        .zero(zero),
        .pp(pp)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        md = 16'h1234;
        zero = 1;
        double = 0;
        negation = 0;
        $display("Testcase %0d: Zero priority (md=%h, zero=%b)", test_num, md, zero);
        #1;

        check_outputs(17'h00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        md = 16'h0001;
        zero = 0;
        double = 0;
        negation = 0;
        $display("Testcase %0d: Pass-through positive (md=%h)", test_num, md);
        #1;

        check_outputs(17'h00001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        md = 16'h8001;
        zero = 0;
        double = 0;
        negation = 0;
        $display("Testcase %0d: Pass-through negative sign-extension (md=%h)", test_num, md);
        #1;

        check_outputs(17'h18001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        md = 16'h0001;
        zero = 0;
        double = 0;
        negation = 1;
        $display("Testcase %0d: Negation positive input (md=%h, neg=1)", test_num, md);
        #1;

        check_outputs(17'h1FFFE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        md = 16'h8001;
        zero = 0;
        double = 0;
        negation = 1;
        $display("Testcase %0d: Negation negative input (md=%h, neg=1)", test_num, md);
        #1;

        check_outputs(17'h07FFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        md = 16'h0005;
        zero = 0;
        double = 1;
        negation = 0;
        $display("Testcase %0d: Double positive input (md=%h, double=1)", test_num, md);
        #1;

        check_outputs(17'h0000A);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        md = 16'h8001;
        zero = 0;
        double = 1;
        negation = 0;
        $display("Testcase %0d: Double negative input (md=%h, double=1)", test_num, md);
        #1;

        check_outputs(17'h10002);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        md = 16'h0001;
        zero = 0;
        double = 1;
        negation = 1;
        $display("Testcase %0d: Negation and Double (md=%h)", test_num, md);
        #1;

        check_outputs(17'h1FFFC);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        md = 16'h8000;
        zero = 0;
        double = 1;
        negation = 1;
        $display("Testcase %0d: Negation and Double (md=%h)", test_num, md);
        #1;

        check_outputs(17'h0FFFE);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        md = 16'hFFFF;
        zero = 0;
        double = 1;
        negation = 0;
        $display("Testcase %0d: Max Input Double (md=%h)", test_num, md);
        #1;

        check_outputs(17'h1FFFE);
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
        input [16:0] expected_pp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pp === (expected_pp ^ pp ^ expected_pp)) begin
                $display("PASS");
                $display("  Outputs: pp=%h",
                         pp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pp=%h",
                         expected_pp);
                $display("  Got:      pp=%h",
                         pp);
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
