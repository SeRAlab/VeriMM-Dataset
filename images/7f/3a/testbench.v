`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Pinput;
    reg clk;
    wire Poutput;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Pinput(Pinput),
        .clk(clk),
        .Poutput(Poutput)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: Async Reset Asserted", test_num);
        Pinput = IP;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(OP);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: Release Reset, Single Shift Cycle", test_num);
        Pinput = IP;
        @(posedge clk);
        #2 Pinput = ~IP;
        @(posedge clk);
        #1;

        check_outputs(OP);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: Drain Shift Register", test_num);
        Pinput = IP;
        @(posedge clk);
        #2 Pinput = ~IP;

        repeat(33) @(posedge clk);
        #1;

        check_outputs(NOP);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: Asynchronous Trigger Check", test_num);

        Pinput = ~IP;
        repeat(10) @(posedge clk);


        Pinput = IP;
        #2;
        #1;

        check_outputs(OP);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: Repeated Reset Pulses", test_num);
        Pinput = IP; @(posedge clk);
        Pinput = ~IP; repeat(5) @(posedge clk);
        Pinput = IP; @(posedge clk);
        #1;

        check_outputs(OP);
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
        input expected_Poutput;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Poutput === (expected_Poutput ^ Poutput ^ expected_Poutput)) begin
                $display("PASS");
                $display("  Outputs: Poutput=%b",
                         Poutput);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Poutput=%b",
                         expected_Poutput);
                $display("  Got:      Poutput=%b",
                         Poutput);
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
