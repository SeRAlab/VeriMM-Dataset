`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CE;
    reg CLK;
    reg RESET;
    wire CLOCK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CE(CE),
        .CLK(CLK),
        .RESET(RESET),
        .CLOCK(CLOCK)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            CE = 0;
            @(posedge CLK);
            #1;
            RESET = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Toggle Check", test_num);
            reset_dut();
            CE = 1;

            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Period Check", test_num);
            reset_dut();
            CE = 1;

            repeat(10) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clock Enable Gating Check", test_num);
            reset_dut();
            CE = 1;
            repeat(3) @(posedge CLK);
            CE = 0;
            repeat(10) @(posedge CLK);
            CE = 1;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Mid-operation Check", test_num);
            reset_dut();
            CE = 1;
            repeat(4) @(posedge CLK);
            RESET = 1;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle CE Check", test_num);
            reset_dut();
            CE = 0;
            repeat(20) @(posedge CLK);
            #1;
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
        input expected_CLOCK;
        begin
            if (expected_CLOCK === (expected_CLOCK ^ CLOCK ^ expected_CLOCK)) begin
                $display("PASS");
                $display("  Outputs: CLOCK=%b",
                         CLOCK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLOCK=%b",
                         expected_CLOCK);
                $display("  Got:      CLOCK=%b",
                         CLOCK);
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
        $dumpvars(0,CE, CLK, RESET, CLOCK);
    end

endmodule
