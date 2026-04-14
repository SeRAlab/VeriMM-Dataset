`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clkin;
    wire clkout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clkin(clkin),
        .clkout(clkout)
    );

    // Clock generation (10ns period)
    initial begin
        clkin = 0;
        forever #5 clkin = ~clkin;
    end

        task reset_dut;

        begin


            @(negedge clkin);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cycle 1 - Expecting clkout to be LOW (cnt=1)", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cycle 2 - Expecting clkout to be HIGH (cnt=0)", test_num);
            reset_dut();


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cycle 3 - Expecting clkout to be LOW (cnt=1)", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cycle 4 - Expecting clkout to be HIGH (cnt=0)", test_num);
            reset_dut();
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stability check after 10 additional cycles", test_num);
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clkin);
            end
            #1;

            #1;


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
        input expected_clkout;
        begin
            if (expected_clkout === (expected_clkout ^ clkout ^ expected_clkout)) begin
                $display("PASS");
                $display("  Outputs: clkout=%b",
                         clkout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clkout=%b",
                         expected_clkout);
                $display("  Got:      clkout=%b",
                         clkout);
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
        $dumpvars(0,clkin, clkout);
    end

endmodule
