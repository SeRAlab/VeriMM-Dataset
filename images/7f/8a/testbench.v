`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg direction;
    reg load;
    reg reset;
    wire carry;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .direction(direction),
        .load(load),
        .reset(reset),
        .carry(carry),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            direction = 1;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Up Counting");
            reset_dut();
            direction = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h05);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Load Data");
            reset_dut();
            data_in = 8'hA5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(1'b0, 8'hA5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Basic Down Counting from Loaded Value");
            reset_dut();

            data_in = 8'h0A;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            direction = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h07);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Carry Flag at 255 (Upwards)");
            reset_dut();
            data_in = 8'hFE;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            direction = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Wrap-around 255 to 0");
            reset_dut();
            data_in = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            direction = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Wrap-around 0 to 255 (Downwards)");
            reset_dut();
            direction = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Priority Test (Reset vs Load)");
            reset_dut();
            reset = 1;
            load = 1;
            data_in = 8'hFF;
            @(posedge clk);
            #1;
            reset = 0;
            load = 0;
            #1;

            check_outputs(1'b0, 8'h00);
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
        input expected_carry;
        input [7:0] expected_count;
        begin
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, count=%h",
                         carry, count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, count=%h",
                         expected_carry, expected_count);
                $display("  Got:      carry=%b, count=%h",
                         carry, count);
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
        $dumpvars(0,clk, data_in, direction, load, reset, carry, count);
    end

endmodule
