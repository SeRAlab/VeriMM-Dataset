`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ext_clock;
    reg nrst;
    wire lock;
    wire pll_clock;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ext_clock(ext_clock),
        .nrst(nrst),
        .lock(lock),
        .pll_clock(pll_clock)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset State Verification", test_num);
        nrst = 0;
        #200;

        #1;


        check_outputs(1'b0, pll_clock);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Lock Acquisition Verification", test_num);
        nrst = 0;
        #100;
        nrst = 1;


        fork : wait_for_lock
            begin
                wait(lock === 1'b1);
                $display("PLL locked successfully.");
            end
            begin
                #20000;
                $display("Timeout: PLL failed to lock.");
            end
        join_any
        disable wait_for_lock;

        #50;
        #1;

        check_outputs(1'b1, pll_clock);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Re-lock After Mid-run Reset", test_num);


        nrst = 0; #100;
        nrst = 1;
        wait(lock === 1'b1);
        #500;


        nrst = 0;
        #100;
        if (lock === 1'b0) $display("Lock dropped as expected during reset.");

        nrst = 1;
        wait(lock === 1'b1);
        #50;


        #1;



        check_outputs(1'b1, pll_clock);
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
        input expected_lock;
        input expected_pll_clock;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lock === (expected_lock ^ lock ^ expected_lock) &&
                expected_pll_clock === (expected_pll_clock ^ pll_clock ^ expected_pll_clock)) begin
                $display("PASS");
                $display("  Outputs: lock=%b, pll_clock=%b",
                         lock, pll_clock);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lock=%b, pll_clock=%b",
                         expected_lock, expected_pll_clock);
                $display("  Got:      lock=%b, pll_clock=%b",
                         lock, pll_clock);
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
