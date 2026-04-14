`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_IN;
    wire CLK_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_IN(CLK_IN),
        .CLK_OUT(CLK_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_IN = 0;
        forever #5 CLK_IN = ~CLK_IN;
    end

        task reset_dut;

        begin


            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking initial state", test_num);
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Checking CLK_OUT after 4166 cycles (1st toggle)", test_num);

            repeat (4166) @(posedge CLK_IN);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Checking CLK_OUT after 8332 cycles (2nd toggle)", test_num);

            repeat (4166) @(posedge CLK_IN);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Checking CLK_OUT after 12498 cycles (3rd toggle)", test_num);

            repeat (4166) @(posedge CLK_IN);
            #1;
            #1;

            check_outputs(1);
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
        input expected_CLK_OUT;
        begin
            if (expected_CLK_OUT === (expected_CLK_OUT ^ CLK_OUT ^ expected_CLK_OUT)) begin
                $display("PASS");
                $display("  Outputs: CLK_OUT=%b",
                         CLK_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLK_OUT=%b",
                         expected_CLK_OUT);
                $display("  Got:      CLK_OUT=%b",
                         CLK_OUT);
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
        $dumpvars(0,CLK_IN, CLK_OUT);
    end

endmodule
