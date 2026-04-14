`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg [7:0] data_in;
    reg reset_in;
    wire [7:0] data_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .data_in(data_in),
        .reset_in(reset_in),
        .data_out(data_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            reset_in = 1;
            data_in = 8'h00;
            repeat(2) @(posedge clk_in);
            #1 reset_in = 0;
            repeat(1) @(posedge clk_in);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Single Value Transfer (0xAA)", test_num);
            reset_dut();
            @(posedge clk_in);
            data_in <= 8'hAA;

            repeat(3) @(posedge clk_in);
            #1;

            check_outputs(8'hAA, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Single Value Transfer (0x55)", test_num);
            reset_dut();
            @(posedge clk_in);
            data_in <= 8'h55;
            repeat(3) @(posedge clk_in);
            #1;

            check_outputs(8'h55, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Stability Check (0xFF)", test_num);
            reset_dut();
            @(posedge clk_in);
            data_in <= 8'hFF;

            repeat(10) @(posedge clk_in);
            #1;

            check_outputs(8'hFF, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Zero Data Transfer", test_num);
            reset_dut();
            @(posedge clk_in);
            data_in <= 8'h00;
            repeat(3) @(posedge clk_in);

            #1;


            check_outputs(8'h00, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Sequential Changes", test_num);
            reset_dut();
            @(posedge clk_in);
            data_in <= 8'h11;
            @(posedge clk_in);
            data_in <= 8'h22;
            @(posedge clk_in);
            data_in <= 8'h33;

            repeat(3) @(posedge clk_in);
            #1;

            check_outputs(8'h33, 1);
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
        input [7:0] expected_data_out;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid_out=%b",
                         data_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid_out=%b",
                         expected_data_out, expected_valid_out);
                $display("  Got:      data_out=%h, valid_out=%b",
                         data_out, valid_out);
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
        $dumpvars(0,clk_in, data_in, reset_in, data_out, valid_out);
    end

endmodule
