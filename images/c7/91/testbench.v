`timescale 1ns/1ps

module max_val_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    wire [15:0] max_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    max_val_module dut (
        .clk(clk),
        .in(in),
        .max_val(max_val)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 0;
            force dut.max_val = 16'h0000;
            @(posedge clk);
            #1;
            release dut.max_val;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic increasing sequence (10, 20, 30)", test_num);
            reset_dut();
            @(negedge clk) in = 16'd10;
            @(negedge clk) in = 16'd20;
            @(negedge clk) in = 16'd30;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Mixed sequence (50, 100, 25)", test_num);
            reset_dut();
            @(negedge clk) in = 16'd50;
            @(negedge clk) in = 16'd100;
            @(negedge clk) in = 16'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: High values (0x7FFF, 0xFFFF, 0x8000)", test_num);
            reset_dut();
            @(negedge clk) in = 16'h7FFF;
            @(negedge clk) in = 16'hFFFF;
            @(negedge clk) in = 16'h8000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: All zero input", test_num);
            reset_dut();
            @(negedge clk) in = 16'h0000;
            @(negedge clk) in = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Repeated maximum value (500, 500, 500)", test_num);
            reset_dut();
            @(negedge clk) in = 16'd500;
            @(negedge clk) in = 16'd500;
            @(negedge clk) in = 16'd500;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd500);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("max_val_module Testbench");
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
        input [15:0] expected_max_val;
        begin
            if (expected_max_val === (expected_max_val ^ max_val ^ expected_max_val)) begin
                $display("PASS");
                $display("  Outputs: max_val=%h",
                         max_val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max_val=%h",
                         expected_max_val);
                $display("  Got:      max_val=%h",
                         max_val);
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
        $dumpvars(0,clk, in, max_val);
    end

endmodule
