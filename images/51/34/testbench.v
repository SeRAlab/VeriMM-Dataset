`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg COUNT18;
    reg COUNT32;
    reg ENABLE;
    reg RESET;
    wire DONE;
    wire EN_BCLK;
    wire RESET_INT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .COUNT18(COUNT18),
        .COUNT32(COUNT32),
        .ENABLE(ENABLE),
        .RESET(RESET),
        .DONE(DONE),
        .EN_BCLK(EN_BCLK),
        .RESET_INT(RESET_INT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RESET = 1;
        ENABLE = 0;
        COUNT18 = 0;
        COUNT32 = 0;
        repeat(2) @(posedge CLK);
        #1;
        RESET = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying E_RESET state outputs", test_num);
        RESET = 1;
        ENABLE = 0;
        COUNT18 = 0;
        COUNT32 = 0;
        repeat(2) @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Transition E_RESET -> E_ESPERA", test_num);
        reset_dut();
        ENABLE = 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Transition E_ESPERA -> E_LEER", test_num);
        reset_dut();
        ENABLE = 1;
        @(posedge CLK);
        #1;
        ENABLE = 0;
        COUNT18 = 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Transition E_LEER -> E_ESPERA via COUNT32", test_num);
        reset_dut();

        ENABLE = 1; @(posedge CLK); #1; ENABLE = 0;

        COUNT18 = 1; @(posedge CLK); #1; COUNT18 = 0;

        COUNT32 = 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Persistence in E_ESPERA", test_num);
        reset_dut();
        ENABLE = 1; @(posedge CLK); #1;
        ENABLE = 0;
        COUNT18 = 0;
        repeat(3) @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Reset override from E_LEER", test_num);
        reset_dut();
        ENABLE = 1; @(posedge CLK); #1;
        COUNT18 = 1; @(posedge CLK); #1;

        RESET = 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1);
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
        input expected_DONE;
        input expected_EN_BCLK;
        input expected_RESET_INT;
        begin
            if (expected_DONE === (expected_DONE ^ DONE ^ expected_DONE) &&
                expected_EN_BCLK === (expected_EN_BCLK ^ EN_BCLK ^ expected_EN_BCLK) &&
                expected_RESET_INT === (expected_RESET_INT ^ RESET_INT ^ expected_RESET_INT)) begin
                $display("PASS");
                $display("  Outputs: DONE=%b, EN_BCLK=%b, RESET_INT=%b",
                         DONE, EN_BCLK, RESET_INT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DONE=%b, EN_BCLK=%b, RESET_INT=%b",
                         expected_DONE, expected_EN_BCLK, expected_RESET_INT);
                $display("  Got:      DONE=%b, EN_BCLK=%b, RESET_INT=%b",
                         DONE, EN_BCLK, RESET_INT);
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
        $dumpvars(0,CLK, COUNT18, COUNT32, ENABLE, RESET, DONE, EN_BCLK, RESET_INT);
    end

endmodule
