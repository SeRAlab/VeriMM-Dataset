`timescale 1ns/1ps

module lfsr_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_8bit dut (
        .clk(clk),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Reset check");
            reset_dut();
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: 1 clock cycle");
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: 5 clock cycles");
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h23);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: 10 clock cycles");
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h71);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: 15 clock cycles");
            reset_dut();
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h24);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: 20 clock cycles");
            reset_dut();
            repeat(20) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h9B);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: 25 clock cycles");
            reset_dut();
            repeat(25) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h72);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_out;
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
        $dumpvars(0,clk, reset, out);
    end

endmodule
