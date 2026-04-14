`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] D;
    reg Load;
    reg clk;
    reg not_reset;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .Load(Load),
        .clk(clk),
        .not_reset(not_reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        not_reset = 0;
        Load = 0;
        D = 16'h0000;
        @(negedge clk);
        not_reset = 1;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Power-on Reset check", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Load 0xAAAA", test_num);
        reset_dut();
        D = 16'hAAAA;
        Load = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Hold behavior (Load=0)", test_num);
        reset_dut();


        D = 16'hFFFF;
        Load = 1;
        @(posedge clk);


        @(negedge clk);
        Load = 0;
        D = 16'h1234;
        @(posedge clk);
        #2;

        #1;


        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Reset priority over Load", test_num);
        reset_dut();


        D = 16'h5555;
        Load = 1;
        not_reset = 0;
        @(posedge clk);
        #2;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Sequential Loading 0x1234 then 0x5678", test_num);
        reset_dut();

        D = 16'h1234;
        Load = 1;
        @(posedge clk);

        @(negedge clk);
        D = 16'h5678;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'h5678);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Toggle Load signal with 0x0000", test_num);
        reset_dut();


        D = 16'hFFFF;
        Load = 1;
        @(posedge clk);


        @(negedge clk);
        D = 16'h0000;
        Load = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
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
        $dumpvars(0,D, Load, clk, not_reset, Q);
    end

endmodule
