`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    wire CLKOUT;
    wire CLKOUTn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST),
        .CLKOUT(CLKOUT),
        .CLKOUTn(CLKOUTn)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            repeat(2) @(posedge CLK);
            #2;
            RST = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check CLKOUT toggles to HIGH after 300,000 cycles", test_num);
            reset_dut();

            repeat(300000) @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check CLKOUT toggles back to LOW after 600,000 cycles", test_num);
            reset_dut();

            repeat(600000) @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset mid-cycle clears counter", test_num);
            reset_dut();

            repeat(150000) @(posedge CLK);

            reset_dut();


            repeat(200000) @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_CLKOUT;
        input expected_CLKOUTn;
        begin
            if (expected_CLKOUT === (expected_CLKOUT ^ CLKOUT ^ expected_CLKOUT) &&
                expected_CLKOUTn === (expected_CLKOUTn ^ CLKOUTn ^ expected_CLKOUTn)) begin
                $display("PASS");
                $display("  Outputs: CLKOUT=%b, CLKOUTn=%b",
                         CLKOUT, CLKOUTn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLKOUT=%b, CLKOUTn=%b",
                         expected_CLKOUT, expected_CLKOUTn);
                $display("  Got:      CLKOUT=%b, CLKOUTn=%b",
                         CLKOUT, CLKOUTn);
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
        $dumpvars(0,CLK, RST, CLKOUT, CLKOUTn);
    end

endmodule
