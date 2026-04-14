`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] a;
    reg [5:0] b;
    reg clk;
    reg hold;
    wire [11:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .hold(hold),
        .c(c)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            hold = 0;
            @(posedge clk);
            #1;

        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive Multiplication", test_num);
            reset_dut();
            a = 6'sd5; b = 6'sd4;
            @(posedge clk);
            #1;
            expected_acc = expected_acc + (a * b);
            #1;

            check_outputs(expected_acc);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative Multiplication", test_num);
            reset_dut();
            a = -6'sd3; b = 6'sd4;
            @(posedge clk);
            #1;
            expected_acc = expected_acc + (a * b);
            #1;

            check_outputs(expected_acc);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Double Negative Multiplication", test_num);
            reset_dut();
            a = -6'sd2; b = -6'sd5;
            @(posedge clk);
            #1;
            expected_acc = expected_acc + (a * b);
            #1;

            check_outputs(expected_acc);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold Signal Verification", test_num);
            reset_dut();
            hold = 1;
            a = 6'sd10; b = 6'sd2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(expected_acc);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Inputs", test_num);
            reset_dut();
            a = 6'sd0; b = 6'sd15;
            @(posedge clk);
            #1;
            expected_acc = expected_acc + (a * b);
            #1;

            check_outputs(expected_acc);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Signed Values", test_num);
            reset_dut();
            a = -6'sd32; b = 6'sd31;
            @(posedge clk);
            #1;
            expected_acc = expected_acc + (a * b);
            #1;

            check_outputs(expected_acc);
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
        input [11:0] expected_c;
        begin
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
        $dumpvars(0,a, b, clk, hold, c);
    end

endmodule
