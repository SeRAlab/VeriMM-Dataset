`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    reg [31:0] in2;
    reg reset;
    wire final_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .in2(in2),
        .reset(reset),
        .final_output(final_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 8'h00;
            in2 = 32'h00000000;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            in = 8'h01;
            in2 = 32'h0;
            @(posedge clk);
            #1;
            $display("Test Case 001: Odd Parity, No Edge");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            in = 8'h03;
            in2 = 32'h0;
            @(posedge clk);
            #1;
            $display("Test Case 002: Even Parity, No Edge");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            in = 8'h00;
            in2 = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            in2 = 32'h00000000;
            @(posedge clk);
            #1;
            $display("Test Case 003: Even Parity + Falling Edge Trigger");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            in = 8'h01;
            in2 = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            in2 = 32'h00000000;
            @(posedge clk);
            #1;
            $display("Test Case 004: Odd Parity + Falling Edge Trigger");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            in = 8'h01;
            in2 = 32'hFFFFFFFF;
            @(posedge clk);
            in2 = 32'h0;
            @(posedge clk);

            in2 = 32'h0;
            @(posedge clk);
            #1;
            $display("Test Case 005: Return to Parity state after Edge Pulse");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            in = 8'hFF;
            in2 = 32'h12345678;
            @(posedge clk);
            #1;
            $display("Test Case 006: All bits high parity");
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
        input expected_final_output;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output)) begin
                $display("PASS");
                $display("  Outputs: final_output=%b",
                         final_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%b",
                         expected_final_output);
                $display("  Got:      final_output=%b",
                         final_output);
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
        $dumpvars(0,clk, in, in2, reset, final_output);
    end

endmodule
