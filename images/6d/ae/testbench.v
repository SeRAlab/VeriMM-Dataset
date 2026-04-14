`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg cs_;
    reg oe_;
    reg rst_;
    reg we_;
    wire interrupt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .cs_(cs_),
        .oe_(oe_),
        .rst_(rst_),
        .we_(we_),
        .interrupt(interrupt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_ = 0;
        addr = 0;
        cs_ = 1;
        oe_ = 1;
        we_ = 1;
        en_data = 0;
        data_out = 0;
        repeat(2) @(posedge clk);
        rst_ = 1;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();

        #1;
        $display("Testcase 001: Initial Reset - Count is 0");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();

        write_reg(8'h00, 8'h14);

        repeat(5) @(posedge clk);
        #1;
        $display("Testcase 002: Count is 5, Threshold is 20 - Interrupt should be 0");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();

        write_reg(8'h00, 8'h05);

        repeat(10) @(posedge clk);
        #1;
        $display("Testcase 003: Count > Threshold - Interrupt should be 1");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();

        write_reg(8'h00, 8'h05);
        repeat(10) @(posedge clk);


        write_reg(8'h00, 8'h64);
        #1;
        $display("Testcase 004: Dynamically raised threshold - Interrupt should clear to 0");
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
        input expected_interrupt;
        begin
            if (expected_interrupt === (expected_interrupt ^ interrupt ^ expected_interrupt)) begin
                $display("PASS");
                $display("  Outputs: interrupt=%b",
                         interrupt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interrupt=%b",
                         expected_interrupt);
                $display("  Got:      interrupt=%b",
                         interrupt);
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
        $dumpvars(0,addr, clk, cs_, oe_, rst_, we_, interrupt);
    end

endmodule
