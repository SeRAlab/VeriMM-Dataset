`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg data_in;
    wire data_decoded;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .data_in(data_in),
        .data_decoded(data_decoded),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            data_in = 0;
            @(posedge clk_in);
            @(negedge clk_in);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data_in = 0;
            @(posedge clk_in);
            #2;
            $display("Testcase 001: Data In = 0, Checking High Clock Phase");
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 1;
            @(posedge clk_in);
            #2;
            $display("Testcase 002: Data In = 1, Checking High Clock Phase");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 0;
            @(negedge clk_in);
            #2;
            $display("Testcase 003: Data In = 0, Checking Low Clock Phase");

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 1;
            @(negedge clk_in);
            #2;
            $display("Testcase 004: Data In = 1, Checking Low Clock Phase");

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_in = 0;
            @(posedge clk_in);
            @(negedge clk_in);
            data_in = 1;
            @(posedge clk_in);
            #2;
            $display("Testcase 005: Transition 0 -> 1, Checking High Clock Phase");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data_in = 1;
            @(posedge clk_in);
            @(negedge clk_in);
            data_in = 0;
            @(posedge clk_in);
            #2;
            $display("Testcase 006: Transition 1 -> 0, Checking High Clock Phase");
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_data_decoded;
        input expected_data_out;
        begin
            if (expected_data_decoded === (expected_data_decoded ^ data_decoded ^ expected_data_decoded) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_decoded=%b, data_out=%b",
                         data_decoded, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_decoded=%b, data_out=%b",
                         expected_data_decoded, expected_data_out);
                $display("  Got:      data_decoded=%b, data_out=%b",
                         data_decoded, data_out);
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
        $dumpvars(0,clk_in, data_in, data_decoded, data_out);
    end

endmodule
