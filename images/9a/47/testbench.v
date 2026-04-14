`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] johnson_state;
    reg [3:0] q;
    reg reset;
    reg select;
    wire [19:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .johnson_state(johnson_state),
        .q(q),
        .reset(reset),
        .select(select),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        select = 0;
        johnson_state = 16'h0;
        q = 4'h0;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();



        reset = 1;
        johnson_state = 16'hFFFF;
        q = 4'hF;
        @(posedge clk);
        #1;
        $display("Testcase 001: Checking Reset functionality");
        #1;

        check_outputs(20'h00000);
        reset = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        johnson_state = 16'hA5A5;
        q = 4'hF;
        select = 0;
        @(posedge clk);
        #1;
        $display("Testcase 002: Johnson state extension (select=0)");
        #1;

        check_outputs(20'h0A5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        johnson_state = 16'h000F;
        q = 4'h1;
        select = 1;
        @(posedge clk);
        #1;
        $display("Testcase 003: Sum functionality (select=1)");
        #1;

        check_outputs(20'h00010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        johnson_state = 16'hFFFF;
        q = 4'h1;
        select = 1;
        @(posedge clk);
        #1;
        $display("Testcase 004: Sum with carry (select=1)");
        #1;

        check_outputs(20'h10000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        johnson_state = 16'h1234;
        q = 4'h5;
        select = 1;
        @(posedge clk);

        select = 0;
        @(posedge clk);
        #1;
        $display("Testcase 005: Select transition from 1 to 0");
        #1;

        check_outputs(20'h01234);
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
        input [19:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, johnson_state, q, reset, select, out);
    end

endmodule
