`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg in;
    wire out;
    wire out0;
    wire out1;
    wire out2;
    wire out3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out),
        .out0(out0),
        .out1(out1),
        .out2(out2),
        .out3(out3)
    );

    // Clock generation (10ns period)
    initial begin
        in = 0;
        forever #5 in = ~in;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            $display("DUT Reset at time %0t", $time);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: 4-Sample Fill (1, 0, 1, 1)", test_num);
            reset_dut();

            in = 1; @(posedge clk);
            in = 0; @(posedge clk);
            in = 1; @(posedge clk);
            in = 1; @(posedge clk);

            #1;

            #1;


            check_outputs(4'b1101, 1, 0, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Wrap-around Check (6 samples: 1, 0, 1, 1, 0, 1)", test_num);
            reset_dut();


            in = 1; @(posedge clk);
            in = 0; @(posedge clk);
            in = 1; @(posedge clk);
            in = 1; @(posedge clk);


            in = 0; @(posedge clk);
            in = 1; @(posedge clk);

            #1;

            #1;


            check_outputs(4'b1110, 0, 1, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Full Cycle Overwrite (1, 1, 0, 0, 1, 0, 1, 0)", test_num);
            reset_dut();


            in = 1; @(posedge clk); in = 1; @(posedge clk);
            in = 0; @(posedge clk); in = 0; @(posedge clk);


            in = 1; @(posedge clk);
            in = 0; @(posedge clk);
            in = 1; @(posedge clk);
            in = 0; @(posedge clk);

            #1;

            #1;


            check_outputs(4'b0101, 1, 0, 1, 0);
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
        input expected_out;
        input expected_out0;
        input expected_out1;
        input expected_out2;
        input expected_out3;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3)) begin
                $display("PASS");
                $display("  Outputs: out=%b, out0=%b, out1=%b, out2=%b, out3=%b",
                         out, out0, out1, out2, out3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, out0=%b, out1=%b, out2=%b, out3=%b",
                         expected_out, expected_out0, expected_out1, expected_out2, expected_out3);
                $display("  Got:      out=%b, out0=%b, out1=%b, out2=%b, out3=%b",
                         out, out0, out1, out2, out3);
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
        $dumpvars(0,in, out, out0, out1, out2, out3);
    end

endmodule
