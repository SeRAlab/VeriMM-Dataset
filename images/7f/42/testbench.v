`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] Q;
    reg clk;
    reg rst;
    reg rst_sync;
    wire [3:0] D;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Q(Q),
        .clk(clk),
        .rst(rst),
        .rst_sync(rst_sync),
        .D(D)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        rst_sync = 0;
        Q = 4'h0;
        #15;
        rst = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        @(posedge clk);
        #1 Q = 4'hA;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(posedge clk);
        #1 Q = 4'hF;
        @(posedge clk);
        @(posedge clk);

        #1 rst_sync = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        @(posedge clk);
        #1 Q = 4'h5;
        @(posedge clk);
        @(posedge clk);

        #2 rst = 1;
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        @(posedge clk);
        #1 Q = 4'h3;
        @(posedge clk);
        #1 Q = 4'hC;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        @(posedge clk);
        #1 Q = 4'h9;
        @(posedge clk);
        #1 rst_sync = 1;
        @(posedge clk);
        #1 rst_sync = 0;
        @(posedge clk);
        #2;


        #1;



        check_outputs(4'h9);
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
        input [3:0] expected_D;
        begin
            if (expected_D === (expected_D ^ D ^ expected_D)) begin
                $display("PASS");
                $display("  Outputs: D=%h",
                         D);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h",
                         expected_D);
                $display("  Got:      D=%h",
                         D);
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
        $dumpvars(0,Q, clk, rst, rst_sync, D);
    end

endmodule
