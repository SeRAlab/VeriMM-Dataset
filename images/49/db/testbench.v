`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CE;
    reg CLK;
    reg D;
    reg RESET;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CE(CE),
        .CLK(CLK),
        .D(D),
        .RESET(RESET),
        .Q(Q)
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
        D = 0;
        #12;
        RESET = 0;
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Test %0d: Basic Reset", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(negedge CLK);
        D = 1;
        CE = 1;
        @(posedge CLK);
        #2;
        $display("Test %0d: Synchronous Load High", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        @(negedge CLK);
        D = 1; CE = 1;
        @(posedge CLK);

        @(negedge CLK);
        D = 0;
        @(posedge CLK);
        #2;
        $display("Test %0d: Synchronous Load Low", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        @(negedge CLK);
        D = 1; CE = 1;
        @(posedge CLK);

        @(negedge CLK);
        CE = 0;
        D = 0;
        @(posedge CLK);
        #2;
        $display("Test %0d: Clock Enable Disabled (Hold)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        @(negedge CLK);
        D = 1; CE = 1;
        @(posedge CLK);
        #2;

        RESET = 1;
        #1;
        $display("Test %0d: Asynchronous Reset Priority", test_num);
        #1;

        check_outputs(1'b0);
        RESET = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        @(negedge CLK);
        D = 1;
        CE = 1;
        RESET = 1;
        @(posedge CLK);
        #2;
        $display("Test %0d: Reset over CE Priority", test_num);
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
        testcase006();
        
        
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,CE, CLK, D, RESET, Q);
    end

endmodule
