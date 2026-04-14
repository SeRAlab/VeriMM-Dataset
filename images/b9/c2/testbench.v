`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg atb0out;
    reg atb1out;
    wire atbcompout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .atb0out(atb0out),
        .atb1out(atb1out),
        .atbcompout(atbcompout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: atb0out=0, atb1out=0");
        atb0out = 1'b0;
        atb1out = 1'b0;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: atb0out=0, atb1out=1");
        atb0out = 1'b0;
        atb1out = 1'b1;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: atb0out=1, atb1out=0");
        atb0out = 1'b1;
        atb1out = 1'b0;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: atb0out=1, atb1out=1");
        atb0out = 1'b1;
        atb1out = 1'b1;
        #10;
        #1;

        check_outputs(1'b0);
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
        input expected_atbcompout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_atbcompout === (expected_atbcompout ^ atbcompout ^ expected_atbcompout)) begin
                $display("PASS");
                $display("  Outputs: atbcompout=%b",
                         atbcompout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: atbcompout=%b",
                         expected_atbcompout);
                $display("  Got:      atbcompout=%b",
                         atbcompout);
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
