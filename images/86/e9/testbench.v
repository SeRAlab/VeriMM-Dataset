`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg serial_in;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .serial_in(serial_in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            serial_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load 1 and shift left twice with 0s", test_num);
            reset_dut();
            load = 1; serial_in = 1; @(posedge clk); #1;
            load = 0; serial_in = 0; @(posedge clk); #1;
            load = 0; serial_in = 0; @(posedge clk); #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load 1 and shift left twice with 1s", test_num);
            reset_dut();
            load = 1; serial_in = 1; @(posedge clk); #1;
            load = 0; serial_in = 1; @(posedge clk); #1;
            load = 0; serial_in = 1; @(posedge clk); #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load 1, shift 1, then re-load 0", test_num);
            reset_dut();
            load = 1; serial_in = 1; @(posedge clk); #1;
            load = 0; serial_in = 1; @(posedge clk); #1;
            load = 1; serial_in = 0; @(posedge clk); #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequence Load 1 -> Shift 1 -> Shift 0", test_num);
            reset_dut();
            load = 1; serial_in = 1; @(posedge clk); #1;
            load = 0; serial_in = 1; @(posedge clk); #1;
            load = 0; serial_in = 0; @(posedge clk); #1;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Consecutive loads (1 then 1)", test_num);
            reset_dut();
            load = 1; serial_in = 1; @(posedge clk); #1;
            load = 1; serial_in = 1; @(posedge clk); #1;
            #1;

            check_outputs(3'b001);
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
        input [2:0] expected_out;
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
        $dumpvars(0,clk, load, serial_in, out);
    end

endmodule
