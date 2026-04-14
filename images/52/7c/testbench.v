`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pll_locked;
    reg reset;
    wire SYNC_DONE;
    wire TXENPMAPHASEALIGN;
    wire TXPMASETPHASE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pll_locked(pll_locked),
        .reset(reset),
        .SYNC_DONE(SYNC_DONE),
        .TXENPMAPHASEALIGN(TXENPMAPHASEALIGN),
        .TXPMASETPHASE(TXPMASETPHASE)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            reset = 1;
            pll_locked = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Normal Sequence to Completion", test_num);
            reset_dut();


            repeat(5) @(posedge clk);
            pll_locked = 1;



            repeat(500) @(posedge clk);




            #1;





            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: PLL Never Locks", test_num);
            reset_dut();

            pll_locked = 0;
            repeat(200) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-Process", test_num);
            reset_dut();

            pll_locked = 1;

            repeat(20) @(posedge clk);


            reset = 1;
            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Delayed PLL Lock", test_num);
            reset_dut();

            pll_locked = 0;
            repeat(100) @(posedge clk);


            if (SYNC_DONE == 0 && TXENPMAPHASEALIGN == 0) begin
                $display("Status: Waiting for PLL as expected.");
            end

            pll_locked = 1;
            repeat(500) @(posedge clk);


            #1;



            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: PLL Lock Loss", test_num);
            reset_dut();

            pll_locked = 1;
            repeat(500) @(posedge clk);


            pll_locked = 0;
            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_SYNC_DONE;
        input expected_TXENPMAPHASEALIGN;
        input expected_TXPMASETPHASE;
        begin
            if (expected_SYNC_DONE === (expected_SYNC_DONE ^ SYNC_DONE ^ expected_SYNC_DONE) &&
                expected_TXENPMAPHASEALIGN === (expected_TXENPMAPHASEALIGN ^ TXENPMAPHASEALIGN ^ expected_TXENPMAPHASEALIGN) &&
                expected_TXPMASETPHASE === (expected_TXPMASETPHASE ^ TXPMASETPHASE ^ expected_TXPMASETPHASE)) begin
                $display("PASS");
                $display("  Outputs: SYNC_DONE=%b, TXENPMAPHASEALIGN=%b, TXPMASETPHASE=%b",
                         SYNC_DONE, TXENPMAPHASEALIGN, TXPMASETPHASE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SYNC_DONE=%b, TXENPMAPHASEALIGN=%b, TXPMASETPHASE=%b",
                         expected_SYNC_DONE, expected_TXENPMAPHASEALIGN, expected_TXPMASETPHASE);
                $display("  Got:      SYNC_DONE=%b, TXENPMAPHASEALIGN=%b, TXPMASETPHASE=%b",
                         SYNC_DONE, TXENPMAPHASEALIGN, TXPMASETPHASE);
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
        $dumpvars(0,clk, pll_locked, reset, SYNC_DONE, TXENPMAPHASEALIGN, TXPMASETPHASE);
    end

endmodule
