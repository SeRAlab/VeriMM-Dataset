`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg en;
    reg load;
    reg reset;
    wire carry_out;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .load(load),
        .reset(reset),
        .carry_out(carry_out),
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
            en = 0;
            load = 0;
            data_in = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Basic Reset");
            reset_dut();

            #1;


            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Load Data 4'hA");
            reset_dut();
            data_in = 4'hA;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(1'b0, 4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Increment 3 times");
            reset_dut();
            en = 1;
            repeat(3) @(posedge clk);
            #1 en = 0;

            #1;


            check_outputs(1'b0, 4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Check Carry Out at Max Value (15)");
            reset_dut();
            data_in = 4'hF;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Overflow 15 to 0");
            reset_dut();
            data_in = 4'hF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            en = 1;
            @(posedge clk);
            #1 en = 0;

            #1;


            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Enable logic (en=0)");
            reset_dut();
            en = 1;
            repeat(2) @(posedge clk);
            #1 en = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b0010);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Load priority over increment");
            reset_dut();
            en = 1;
            data_in = 4'h7;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(1'b0, 4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Sequential Load 15 then 0");
            reset_dut();
            data_in = 4'hF;
            load = 1;
            @(posedge clk);
            #1 data_in = 4'h0;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(1'b0, 4'h0);
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
        input expected_carry_out;
        input [3:0] expected_data_out;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, data_out=%h",
                         carry_out, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, data_out=%h",
                         expected_carry_out, expected_data_out);
                $display("  Got:      carry_out=%b, data_out=%h",
                         carry_out, data_out);
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
        $dumpvars(0,clk, data_in, en, load, reset, carry_out, data_out);
    end

endmodule
