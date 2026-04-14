`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in1;
    reg [31:0] data_in2;
    reg reset;
    wire [31:0] sum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .reset(reset),
        .sum_out(sum_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in1 = 0;
            data_in2 = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data_in1 = 32'h01020304;
            data_in2 = 32'h10203040;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h11223344);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            data_in1 = 32'hFFFFFFFF;
            data_in2 = 32'h01000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            data_in1 = 32'hFFFFFFFF;
            data_in2 = 32'h01000000;
            @(posedge clk);

            data_in1 = 32'h00000000;
            data_in2 = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h01000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            data_in1 = 32'hD0C0B0A0;
            data_in2 = 32'h10101010;
            @(posedge clk);

            data_in1 = 32'hF0F0F0F0;
            data_in2 = 32'h10101010;
            @(posedge clk);

            data_in1 = 32'h00000000;
            data_in2 = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h01000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            data_in1 = 32'hFFFFFFFF;
            data_in2 = 32'h01000000;
            @(posedge clk);

            reset = 1;
            @(posedge clk);
            reset = 0;

            data_in1 = 32'h00000000;
            data_in2 = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
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
        input [31:0] expected_sum_out;
        begin
            if (expected_sum_out === (expected_sum_out ^ sum_out ^ expected_sum_out)) begin
                $display("PASS");
                $display("  Outputs: sum_out=%h",
                         sum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum_out=%h",
                         expected_sum_out);
                $display("  Got:      sum_out=%h",
                         sum_out);
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
        $dumpvars(0,clk, data_in1, data_in2, reset, sum_out);
    end

endmodule
