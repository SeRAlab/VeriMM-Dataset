`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire ampm;
    wire [1:0] hour;
    wire [5:0] minute;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .ampm(ampm),
        .hour(hour),
        .minute(minute),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            #10;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial state after reset (Assuming 12:00 AM)", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 2'b00, 6'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: After 1 clock cycle (12:01 AM)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 2'b00, 6'd1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: After 60 clock cycles (1:00 AM)", test_num);
            reset_dut();
            repeat(60) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b01, 6'd0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: After 180 clock cycles (3:00 AM)", test_num);
            reset_dut();
            repeat(180) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b11, 6'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: After 719 clock cycles (11:59 AM)", test_num);
            reset_dut();
            repeat(719) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b11, 6'd59, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: After 720 clock cycles (12:00 PM - Transition)", test_num);
            reset_dut();
            repeat(720) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'b00, 6'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: After 721 clock cycles (12:01 PM - Valid Low)", test_num);
            reset_dut();
            repeat(721) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 2'b00, 6'd1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: After 1440 clock cycles (12:00 AM - Cycle Complete)", test_num);
            reset_dut();
            repeat(1440) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b00, 6'd0, 1'b0);
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
        input expected_ampm;
        input [1:0] expected_hour;
        input [5:0] expected_minute;
        input expected_valid;
        begin
            if (expected_ampm === (expected_ampm ^ ampm ^ expected_ampm) &&
                expected_hour === (expected_hour ^ hour ^ expected_hour) &&
                expected_minute === (expected_minute ^ minute ^ expected_minute) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: ampm=%b, hour=%h, minute=%h, valid=%b",
                         ampm, hour, minute, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ampm=%b, hour=%h, minute=%h, valid=%b",
                         expected_ampm, expected_hour, expected_minute, expected_valid);
                $display("  Got:      ampm=%b, hour=%h, minute=%h, valid=%b",
                         ampm, hour, minute, valid);
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
        $dumpvars(0,clk, reset, ampm, hour, minute, valid);
    end

endmodule
