`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg FM;
    wire SSC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .FM(FM),
        .SSC(SSC)
    );

        task reset_dut;

        begin
            FM = 0;

            repeat(10) @(posedge CLK);
            $display("System Initialized/Reset.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: FM = 0 Operation", test_num);
            reset_dut();

            FM = 0;


            repeat(2000) @(posedge CLK);



            #1;




            check_outputs(SSC);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: FM = 1 Operation", test_num);
            reset_dut();

            FM = 1;

            repeat(2000) @(posedge CLK);

            #1;


            check_outputs(SSC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Dynamic FM Transition", test_num);
            reset_dut();

            FM = 0;
            repeat(500) @(posedge CLK);
            FM = 1;
            repeat(500) @(posedge CLK);
            FM = 0;
            repeat(1000) @(posedge CLK);

            #1;


            check_outputs(SSC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Long Duration Phase Check", test_num);
            reset_dut();

            FM = 1;

            repeat(10000) @(posedge CLK);

            #1;


            check_outputs(SSC);
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
        input expected_SSC;
        begin
            if (expected_SSC === (expected_SSC ^ SSC ^ expected_SSC)) begin
                $display("PASS");
                $display("  Outputs: SSC=%b",
                         SSC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SSC=%b",
                         expected_SSC);
                $display("  Got:      SSC=%b",
                         SSC);
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
        $dumpvars(0,CLK, FM, SSC);
    end

endmodule
