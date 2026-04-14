`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ar;
    reg clk;
    wire q;
    wire [7:0] sr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ar(ar),
        .clk(clk),
        .q(q),
        .sr(sr)
    );

    // Clock generation (10ns period)
    initial begin
        ar = 0;
        forever #5 ar = ~ar;
    end

        task reset_dut;

        begin
            ar = 0;
            #12;
            ar = 1;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0, 8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Shift Verification", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h02);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nTestcase %0d: MSB (q) Tracking", test_num);
            reset_dut();

            for (i = 0; i < 7; i = i + 1) begin
                @(posedge clk);
            end
            #1;


            #1;



            check_outputs(1'b1, 8'h8e);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nTestcase %0d: Feedback Loop Verification", test_num);
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(1'b0, 8'h1c);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Asynchronous Reset Mid-cycle", test_num);
            reset_dut();
            @(posedge clk);
            #2;
            @(posedge clk);
            #2;
            ar = 0;
            #1;
            #1;

            check_outputs(1'b0, 8'h01);
            ar = 1;
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
        input expected_q;
        input [7:0] expected_sr;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_sr === (expected_sr ^ sr ^ expected_sr)) begin
                $display("PASS");
                $display("  Outputs: q=%b, sr=%h",
                         q, sr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, sr=%h",
                         expected_q, expected_sr);
                $display("  Got:      q=%b, sr=%h",
                         q, sr);
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
        $dumpvars(0,ar, clk, q, sr);
    end

endmodule
