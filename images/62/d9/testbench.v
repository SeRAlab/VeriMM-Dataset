`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg clk;
    reg clk2;
    wire [7:0] q;
    wire [7:0] q2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .clk2(clk2),
        .q(q),
        .q2(q2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 8'h00;
            clk2 = 0;

            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 8'hAA;


            @(posedge clk);
            #1;


            #5 clk2 = 1;
            #5;

            $display("Testcase 001: Capture same value on both clocks");
            #1;

            check_outputs(8'hAA, 8'hAA);
            clk2 = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            a = 8'h11;
            @(posedge clk);
            #2;


            a = 8'h22;
            #5 clk2 = 1;
            #5;

            $display("Testcase 002: Capture different values (q=11, q2=22)");
            #1;

            check_outputs(8'h11, 8'h22);
            clk2 = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            a = 8'h55;
            @(posedge clk);
            #5;


            a = 8'hFF;
            #10;

            $display("Testcase 003: Only clk triggers (q=55, q2=00)");
            #1;

            check_outputs(8'h55, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(posedge clk);
            #2;

            a = 8'hCC;
            #5 clk2 = 1;
            #5;


            a = 8'h00;

            $display("Testcase 004: Only clk2 triggers (q=00, q2=CC)");
            #1;

            check_outputs(8'h00, 8'hCC);
            clk2 = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            a = 8'hF0;
            @(posedge clk);
            #2;
            a = 8'h0F;
            #3 clk2 = 1;
            #2;


            a = 8'hA5;
            @(posedge clk);
            #2;

            $display("Testcase 005: Multi-step capture (q=A5, q2=0F)");
            #1;

            check_outputs(8'hA5, 8'h0F);
            clk2 = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            a = 8'hFF;
            @(posedge clk);
            #2 clk2 = 1;
            #5;

            $display("Testcase 006: Boundary values (All 1s)");
            #1;

            check_outputs(8'hFF, 8'hFF);
            clk2 = 0;
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
        input [7:0] expected_q;
        input [7:0] expected_q2;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2)) begin
                $display("PASS");
                $display("  Outputs: q=%h, q2=%h",
                         q, q2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, q2=%h",
                         expected_q, expected_q2);
                $display("  Got:      q=%h, q2=%h",
                         q, q2);
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
        $dumpvars(0,a, clk, clk2, q, q2);
    end

endmodule
