`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] sig;
    wire [15:0] sig_buf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sig(sig),
        .sig_buf(sig_buf)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: All Zeros", test_num);
        sig = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: All Ones", test_num);
        sig = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Alternating Bits Pattern 1", test_num);
        sig = 16'hAAAA;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Alternating Bits Pattern 2", test_num);
        sig = 16'h5555;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Walking One", test_num);
        sig = 16'h0001;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Arbitrary Pattern", test_num);
        sig = 16'h1234;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Another Arbitrary Pattern", test_num);
        sig = 16'hABCD;
        #1;

        check_outputs(16'hABCD);
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
        input [15:0] expected_sig_buf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sig_buf === (expected_sig_buf ^ sig_buf ^ expected_sig_buf)) begin
                $display("PASS");
                $display("  Outputs: sig_buf=%h",
                         sig_buf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sig_buf=%h",
                         expected_sig_buf);
                $display("  Got:      sig_buf=%h",
                         sig_buf);
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
