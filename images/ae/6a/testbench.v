`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg MODE;
    reg R;
    reg TRG_ONE;
    wire POUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .MODE(MODE),
        .R(R),
        .TRG_ONE(TRG_ONE),
        .POUT(POUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            R = 1;
            TRG_ONE = 0;
            MODE = 0;
            @(posedge CLK);
            #2 R = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle State After Reset", test_num);
            reset_dut();
            repeat(2) @(posedge CLK);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse Start on Trigger", test_num);
            reset_dut();
            TRG_ONE = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse Termination (Counter Limit)", test_num);
            reset_dut();
            TRG_ONE = 1;
            @(posedge CLK);
            TRG_ONE = 0;

            repeat(300) @(posedge CLK);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pulse Interruption via Reset", test_num);
            reset_dut();
            TRG_ONE = 1;
            @(posedge CLK);
            TRG_ONE = 0;
            repeat(2) @(posedge CLK);
            R = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Re-triggering in Mode Selection", test_num);
            reset_dut();
            MODE = 1;
            TRG_ONE = 1;
            @(posedge CLK);
            TRG_ONE = 0;
            repeat(5) @(posedge CLK);
            TRG_ONE = 1;
            @(posedge CLK);
            TRG_ONE = 0;

            #2 #1;
 check_outputs(1'b1);
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
        input expected_POUT;
        begin
            if (expected_POUT === (expected_POUT ^ POUT ^ expected_POUT)) begin
                $display("PASS");
                $display("  Outputs: POUT=%b",
                         POUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: POUT=%b",
                         expected_POUT);
                $display("  Got:      POUT=%b",
                         POUT);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,CLK, MODE, R, TRG_ONE, POUT);
    end

endmodule
