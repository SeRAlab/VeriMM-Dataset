`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg shift_left;
    reg shift_right;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            shift_left = 0;
            shift_right = 0;
            data_in = 8'h00;
            @(posedge clk);
            #2 reset = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data_in = 8'hAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 8'h01;
            @(posedge clk);
            #2 shift_left = 1;
            @(negedge clk);
            #2 shift_left = 0;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 8'h80;
            @(posedge clk);
            #2 shift_left = 1;
            @(negedge clk);
            #2 shift_left = 0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data_in = 8'h02;
            @(posedge clk);
            #2 shift_right = 1;
            @(negedge clk);
            #2 shift_right = 0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data_in = 8'h01;
            @(posedge clk);
            #2 shift_right = 1;
            @(negedge clk);
            #2 shift_right = 0;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data_in = 8'h01;
            @(posedge clk);
            #2 shift_left = 1;
            @(negedge clk);
            @(posedge clk);
            #2 shift_left = 0;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            data_in = 8'h55;
            @(posedge clk);
            #2 shift_left = 1;
            @(negedge clk);
            #2 shift_left = 0;
            shift_right = 1;
            @(posedge clk);
            #2 shift_right = 0;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            data_in = 8'h01;
            @(posedge clk);
            #2 shift_left = 1;
            shift_right = 1;
            @(negedge clk);
            #2;


            #1;



            check_outputs(8'h02);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            data_in = 8'hA1;
            @(posedge clk);
            #2 shift_left = 1;

            repeat(4) @(posedge clk);
            #2 shift_left = 0;
            #1;

            check_outputs(8'hA1);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, reset, shift_left, shift_right, data_out);
    end

endmodule
