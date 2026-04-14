`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg alpha;
    reg [31:0] x1;
    reg [31:0] x2;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alpha(alpha),
        .x1(x1),
        .x2(x2),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: alpha=0, Select x1", test_num);
        alpha = 0;
        x1 = 32'hDEADBEEF;
        x2 = 32'h12345678;
        #5;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: alpha=1, Select x2", test_num);
        alpha = 1;
        x1 = 32'hDEADBEEF;
        x2 = 32'h12345678;
        #5;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: alpha=0, Select x1 (All 1s)", test_num);
        alpha = 0;
        x1 = 32'hFFFFFFFF;
        x2 = 32'h00000000;
        #5;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: alpha=1, Select x2 (All 0s)", test_num);
        alpha = 1;
        x1 = 32'hFFFFFFFF;
        x2 = 32'h00000000;
        #5;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: alpha=0, Select x1 (Alternating Bits)", test_num);
        alpha = 0;
        x1 = 32'hAAAAAAAA;
        x2 = 32'h55555555;
        #5;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: alpha=1, Select x2 (Alternating Bits)", test_num);
        alpha = 1;
        x1 = 32'hAAAAAAAA;
        x2 = 32'h55555555;
        #5;
        #1;

        check_outputs(32'h55555555);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
