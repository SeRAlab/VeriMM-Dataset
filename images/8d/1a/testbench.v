`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RESET;
    reg SLOWCLK;
    wire EN_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RESET(RESET),
        .SLOWCLK(SLOWCLK),
        .EN_OUT(EN_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RESET = 1;
        SLOWCLK = 0;
        @(posedge CLK);
        #1;
        RESET = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying Reset State", test_num);
        RESET = 1;
        SLOWCLK = 0;
        #15;
        #1;

        check_outputs(1'b0);
        RESET = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Stability Check (SLOWCLK=0)", test_num);
        reset_dut();


        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Rising Edge Check (SLOWCLK 0->1)", test_num);
        reset_dut();

        SLOWCLK = 0;
        repeat(2) @(posedge CLK);

        SLOWCLK = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Stability Check (SLOWCLK=1)", test_num);
        reset_dut();
        SLOWCLK = 1;

        repeat(2) @(posedge CLK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Falling Edge Check (SLOWCLK 1->0)", test_num);
        reset_dut();

        SLOWCLK = 1;
        repeat(2) @(posedge CLK);

        SLOWCLK = 0;
        @(posedge CLK);
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
        input expected_EN_OUT;
        begin
            if (expected_EN_OUT === (expected_EN_OUT ^ EN_OUT ^ expected_EN_OUT)) begin
                $display("PASS");
                $display("  Outputs: EN_OUT=%b",
                         EN_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EN_OUT=%b",
                         expected_EN_OUT);
                $display("  Got:      EN_OUT=%b",
                         EN_OUT);
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
        $dumpvars(0,CLK, RESET, SLOWCLK, EN_OUT);
    end

endmodule
