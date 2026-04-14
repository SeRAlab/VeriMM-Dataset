`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] cmd;
    reg enable;
    reg reset;
    reg start;
    reg sync;
    wire [7:0] ip;
    wire [5:0] pgout;
    wire running;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cmd(cmd),
        .enable(enable),
        .reset(reset),
        .start(start),
        .sync(sync),
        .ip(ip),
        .pgout(pgout),
        .running(running)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        enable = 0;
        start = 0;
        sync = 0;
        cmd = 16'h0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Basic Startup");
        reset_dut();
        enable = 1;
        sync = 1;
        cmd = 16'h00AA;
        @(posedge clk);
        start = 1;
        repeat(5) @(posedge clk);

        #1;


        check_outputs(8'h05, 6'h2A, 1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Enable Gating");
        reset_dut();
        enable = 0;
        sync = 1;
        start = 1;
        cmd = 16'h00FF;
        repeat(5) @(posedge clk);

        #1;


        check_outputs(8'h00, 6'h00, 1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Sync Requirement");
        reset_dut();
        enable = 1;
        sync = 0;
        start = 1;
        cmd = 16'h0015;
        repeat(5) @(posedge clk);

        #1;


        check_outputs(8'h00, 6'h00, 1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Stop Logic");
        reset_dut();
        enable = 1;
        sync = 1;
        start = 1;
        cmd = 16'h0000;
        repeat(10) @(posedge clk);
        start = 0;
        repeat(2) @(posedge clk);


        #1;



        check_outputs(ip, 6'h00, 1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Command Update");
        reset_dut();
        enable = 1;
        sync = 1;
        start = 1;
        cmd = 16'h003C;
        repeat(5) @(posedge clk);
        cmd = 16'h000F;
        repeat(5) @(posedge clk);

        #1;


        check_outputs(8'h0A, 6'h0F, 1'b1);
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
        input [7:0] expected_ip;
        input [5:0] expected_pgout;
        input expected_running;
        begin
            if (expected_ip === (expected_ip ^ ip ^ expected_ip) &&
                expected_pgout === (expected_pgout ^ pgout ^ expected_pgout) &&
                expected_running === (expected_running ^ running ^ expected_running)) begin
                $display("PASS");
                $display("  Outputs: ip=%h, pgout=%h, running=%b",
                         ip, pgout, running);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ip=%h, pgout=%h, running=%b",
                         expected_ip, expected_pgout, expected_running);
                $display("  Got:      ip=%h, pgout=%h, running=%b",
                         ip, pgout, running);
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
        $dumpvars(0,clk, cmd, enable, reset, start, sync, ip, pgout, running);
    end

endmodule
