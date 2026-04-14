`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN_write_0;
    reg EN_write_1;
    reg EN_write_2;
    reg EN_write_3;
    reg EN_write_4;
    reg write_0;
    reg write_1;
    reg write_2;
    reg write_3;
    reg write_4;
    wire read_0;
    wire read_1;
    wire read_2;
    wire read_3;
    wire read_4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .EN_write_0(EN_write_0),
        .EN_write_1(EN_write_1),
        .EN_write_2(EN_write_2),
        .EN_write_3(EN_write_3),
        .EN_write_4(EN_write_4),
        .write_0(write_0),
        .write_1(write_1),
        .write_2(write_2),
        .write_3(write_3),
        .write_4(write_4),
        .read_0(read_0),
        .read_1(read_1),
        .read_2(read_2),
        .read_3(read_3),
        .read_4(read_4)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        EN_write_0 = 1; write_0 = 0;
        EN_write_1 = 1; write_1 = 0;
        EN_write_2 = 1; write_2 = 0;
        EN_write_3 = 1; write_3 = 0;
        EN_write_4 = 1; write_4 = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Write all 1s...");
        reset_dut();
        EN_write_0 = 1; write_0 = 1;
        EN_write_1 = 1; write_1 = 1;
        EN_write_2 = 1; write_2 = 1;
        EN_write_3 = 1; write_3 = 1;
        EN_write_4 = 1; write_4 = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1, 1, 1, 1, 1);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Selective Enable (Even registers)...");
        reset_dut();

        EN_write_0 = 1; write_0 = 1;
        EN_write_1 = 0; write_1 = 1;
        EN_write_2 = 1; write_2 = 1;
        EN_write_3 = 0; write_3 = 1;
        EN_write_4 = 1; write_4 = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1, 0, 1, 0, 1);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Data retention (EN=0)...");
        reset_dut();

        EN_write_0 = 1; write_0 = 1;
        EN_write_1 = 1; write_1 = 0;
        EN_write_2 = 1; write_2 = 1;
        EN_write_3 = 1; write_3 = 0;
        EN_write_4 = 1; write_4 = 1;
        @(posedge CLK);
        #1;

        EN_write_0 = 0; write_0 = 0;
        EN_write_1 = 0; write_1 = 1;
        EN_write_2 = 0; write_2 = 0;
        EN_write_3 = 0; write_3 = 1;
        EN_write_4 = 0; write_4 = 0;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(1, 0, 1, 0, 1);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Multi-cycle sequential updates...");
        reset_dut();

        EN_write_0 = 1; write_0 = 1;
        EN_write_1 = 1; write_1 = 1;
        EN_write_2 = 0;
        EN_write_3 = 0;
        EN_write_4 = 0;
        @(posedge CLK);
        #1;

        EN_write_0 = 1; write_0 = 0;
        EN_write_1 = 0;
        EN_write_2 = 1; write_2 = 1;
        EN_write_3 = 1; write_3 = 1;
        EN_write_4 = 0;
        @(posedge CLK);
        #1;

        EN_write_0 = 0;
        EN_write_1 = 0;
        EN_write_2 = 0;
        EN_write_3 = 0;
        EN_write_4 = 1; write_4 = 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(0, 1, 1, 1, 1);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Bit toggling...");
        reset_dut();

        EN_write_0 = 1; write_0 = 1;
        EN_write_1 = 1; write_1 = 1;
        EN_write_2 = 1; write_2 = 1;
        EN_write_3 = 1; write_3 = 1;
        EN_write_4 = 1; write_4 = 1;
        @(posedge CLK);
        #1;

        EN_write_0 = 1; write_0 = 0;
        EN_write_1 = 1; write_1 = 0;
        EN_write_2 = 1; write_2 = 0;
        EN_write_3 = 1; write_3 = 0;
        EN_write_4 = 1; write_4 = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(0, 0, 0, 0, 0);
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
        input expected_read_0;
        input expected_read_1;
        input expected_read_2;
        input expected_read_3;
        input expected_read_4;
        begin
            if (expected_read_0 === (expected_read_0 ^ read_0 ^ expected_read_0) &&
                expected_read_1 === (expected_read_1 ^ read_1 ^ expected_read_1) &&
                expected_read_2 === (expected_read_2 ^ read_2 ^ expected_read_2) &&
                expected_read_3 === (expected_read_3 ^ read_3 ^ expected_read_3) &&
                expected_read_4 === (expected_read_4 ^ read_4 ^ expected_read_4)) begin
                $display("PASS");
                $display("  Outputs: read_0=%b, read_1=%b, read_2=%b, read_3=%b, read_4=%b",
                         read_0, read_1, read_2, read_3, read_4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_0=%b, read_1=%b, read_2=%b, read_3=%b, read_4=%b",
                         expected_read_0, expected_read_1, expected_read_2, expected_read_3, expected_read_4);
                $display("  Got:      read_0=%b, read_1=%b, read_2=%b, read_3=%b, read_4=%b",
                         read_0, read_1, read_2, read_3, read_4);
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
        $dumpvars(0,CLK, EN_write_0, EN_write_1, EN_write_2, EN_write_3, EN_write_4, write_0, write_1, write_2, write_3, write_4, read_0, read_1, read_2, read_3, read_4);
    end

endmodule
