`timescale 1ns/1ps

module lfsr_5bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in_bit;
    reg rst;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_5bit dut (
        .clk(clk),
        .in_bit(in_bit),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_bit = 0;
            repeat(2) @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single 1-bit Propagation", test_num);
            reset_dut();

            in_bit = 1; @(posedge clk); #1;
            in_bit = 0; @(posedge clk); #1;
            in_bit = 0; @(posedge clk); #1;
            in_bit = 0; @(posedge clk); #1;
            in_bit = 0; @(posedge clk); #1;
            in_bit = 0; @(posedge clk); #1;

            #1;


            check_outputs(5'h0B);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Continuous High Input (3 cycles)", test_num);
            reset_dut();

            in_bit = 1; @(posedge clk); #1;
            in_bit = 1; @(posedge clk); #1;
            in_bit = 1; @(posedge clk); #1;

            #1;


            check_outputs(5'h06);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Fill Register (5 cycles)", test_num);
            reset_dut();

            in_bit = 1; repeat(5) begin @(posedge clk); #1; end

            #1;


            check_outputs(5'h19);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Alternating Input (1010)", test_num);
            reset_dut();

            in_bit = 1; @(posedge clk); #1;
            in_bit = 0; @(posedge clk); #1;
            in_bit = 1; @(posedge clk); #1;
            in_bit = 0; @(posedge clk); #1;

            #1;


            check_outputs(5'h08);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_5bit Testbench");
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
        input [4:0] expected_out;
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
        $dumpvars(0,clk, in_bit, rst, out);
    end

endmodule
