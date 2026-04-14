`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] IN;
    reg PL;
    reg SL;
    reg SR;
    reg clk;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IN(IN),
        .PL(PL),
        .SL(SL),
        .SR(SR),
        .clk(clk),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            PL = 1;
            IN = 4'b0000;
            SL = 0;
            SR = 0;
            @(posedge clk);
            #1;
            PL = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(negedge clk);
            PL = 1;
            IN = 4'b1011;
            @(posedge clk);
            #1;
            PL = 0;
            $display("Testcase 001: Parallel Load 1011");
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            @(negedge clk);
            PL = 1; IN = 4'b1000;
            @(posedge clk);
            #1;

            PL = 0; SL = 1; SR = 0;
            @(posedge clk);
            #1;
            SL = 0;
            $display("Testcase 002: Shift Left (1000 -> 0001)");
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            @(negedge clk);
            PL = 1; IN = 4'b0001;
            @(posedge clk);
            #1;

            PL = 0; SL = 0; SR = 1;
            @(posedge clk);
            #1;
            SR = 0;
            $display("Testcase 003: Shift Right (0001 -> 1000)");
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(negedge clk);
            PL = 1; IN = 4'b0110;
            @(posedge clk);
            #1;

            PL = 0; SL = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            SL = 0;
            $display("Testcase 004: Multiple Shift Left (0110 -> 1100 -> 1001)");
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            @(negedge clk);
            PL = 1; IN = 4'b0110;
            @(posedge clk);
            #1;

            PL = 0; SR = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            SR = 0;
            $display("Testcase 005: Multiple Shift Right (0110 -> 0011 -> 1001)");
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            @(negedge clk);
            PL = 1; IN = 4'b0101;
            @(posedge clk);
            #1;

            PL = 1; IN = 4'b1111; SL = 1; SR = 1;
            @(posedge clk);
            #1;
            PL = 0; SL = 0; SR = 0;
            $display("Testcase 006: Priority Test (PL vs Shifts)");
            #1;

            check_outputs(4'b1111);
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,IN, PL, SL, SR, clk, q);
    end

endmodule
