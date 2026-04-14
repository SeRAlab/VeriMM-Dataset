`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in_rst_n;
    wire out_rst_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_rst_n(in_rst_n),
        .out_rst_n(out_rst_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in_rst_n = 0;
            #15;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Asserted Reset Check");
            test_num = test_num + 1;
            reset_dut();

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: De-asserted Reset Synchronization Check");
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            #1;
            in_rst_n = 1;


            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Stability Check");
            test_num = test_num + 1;
            reset_dut();

            in_rst_n = 1;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Asynchronous Assertion Check");
            test_num = test_num + 1;
            reset_dut();


            in_rst_n = 1;
            repeat(2) @(posedge clk);


            #3;
            in_rst_n = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Short Pulse Check");
            test_num = test_num + 1;
            reset_dut();

            in_rst_n = 1;
            @(posedge clk);
            #1;
            in_rst_n = 0;
            #5;
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
        input expected_out_rst_n;
        begin
            if (expected_out_rst_n === (expected_out_rst_n ^ out_rst_n ^ expected_out_rst_n)) begin
                $display("PASS");
                $display("  Outputs: out_rst_n=%b",
                         out_rst_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_rst_n=%b",
                         expected_out_rst_n);
                $display("  Got:      out_rst_n=%b",
                         out_rst_n);
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
        $dumpvars(0,clk, in_rst_n, out_rst_n);
    end

endmodule
