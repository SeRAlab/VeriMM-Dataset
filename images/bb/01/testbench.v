`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg clk;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
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
            a = 16'd0;
            b = 16'd0;
            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            a = 16'd100;
            b = 16'd40;

            repeat (5) @(posedge clk);
            $display("Testcase %0d: 100 - 40", test_num);
            #1;

            check_outputs(16'd60);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            a = 16'd10;
            b = 16'd50;
            repeat (5) @(posedge clk);
            $display("Testcase %0d: 10 - 50", test_num);
            #1;

            check_outputs(-16'd40);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            a = -16'd100;
            b = 16'd50;
            repeat (5) @(posedge clk);
            $display("Testcase %0d: -100 - 50", test_num);
            #1;

            check_outputs(-16'd150);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            a = 16'd200;
            b = -16'd100;
            repeat (5) @(posedge clk);
            $display("Testcase %0d: 200 - (-100)", test_num);
            #1;

            check_outputs(16'd300);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            a = 16'sh7FFF;
            b = 16'sh0001;
            repeat (5) @(posedge clk);
            $display("Testcase %0d: 32767 - 1", test_num);
            #1;

            check_outputs(16'sh7FFE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            a = -16'sh7FFF;
            b = 16'sh0001;
            repeat (5) @(posedge clk);
            $display("Testcase %0d: -32767 - 1", test_num);
            #1;

            check_outputs(16'sh8000);
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
        input [15:0] expected_q;
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
        $dumpvars(0,a, b, clk, q);
    end

endmodule
