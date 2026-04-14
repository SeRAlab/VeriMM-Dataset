`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Bin;
    reg Clk;
    reg Rst;
    wire Bout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Bin(Bin),
        .Clk(Clk),
        .Rst(Rst),
        .Bout(Bout)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Rst = 1;
            Bin = 1;
            @(posedge Clk);
            #1 Rst = 0;
            @(posedge Clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Checking Reset State...");
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Pressing button (Bin: 1 -> 0)...");
            reset_dut();
            Bin = 0;
            repeat(5) @(posedge Clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Releasing button (Bin: 0 -> 1)...");
            reset_dut();
            Bin = 0;
            repeat(5) @(posedge Clk);
            Bin = 1;
            repeat(5) @(posedge Clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Simulating Noisy Press (Bouncing)...");
            reset_dut();

            Bin = 0; #12;
            Bin = 1; #8;
            Bin = 0; #15;
            Bin = 1; #5;
            Bin = 0;
            repeat(10) @(posedge Clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Simulating Noisy Release (Bouncing)...");
            reset_dut();
            Bin = 0;
            repeat(10) @(posedge Clk);

            Bin = 1; #7;
            Bin = 0; #13;
            Bin = 1; #10;
            Bin = 0; #5;
            Bin = 1;
            repeat(10) @(posedge Clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Resetting while button is held down...");
            reset_dut();
            Bin = 0;
            repeat(5) @(posedge Clk);
            Rst = 1;
            repeat(2) @(posedge Clk);
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
        input expected_Bout;
        begin
            if (expected_Bout === (expected_Bout ^ Bout ^ expected_Bout)) begin
                $display("PASS");
                $display("  Outputs: Bout=%b",
                         Bout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Bout=%b",
                         expected_Bout);
                $display("  Got:      Bout=%b",
                         Bout);
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
        $dumpvars(0,Bin, Clk, Rst, Bout);
    end

endmodule
