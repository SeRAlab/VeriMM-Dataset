`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] mux_in1;
    reg [3:0] mux_in2;
    reg reset;
    reg select;
    wire pwm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mux_in1(mux_in1),
        .mux_in2(mux_in2),
        .reset(reset),
        .select(select),
        .pwm(pwm)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1 reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            mux_in1 = 4'd5;
            mux_in2 = 4'd10;
            select = 0;
            reset_dut();


            repeat(3) @(posedge clk);
            #2;
            $display("Test Case 001: Mux1=5, Count=3");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            mux_in1 = 4'd5;
            mux_in2 = 4'd10;
            select = 0;
            reset_dut();
            repeat(6) @(posedge clk);
            #2;
            $display("Test Case 002: Mux1=5, Count=6");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            mux_in1 = 4'd2;
            mux_in2 = 4'd10;
            select = 1;
            reset_dut();
            repeat(4) @(posedge clk);
            #2;
            $display("Test Case 003: Mux2=10, Count=4");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            mux_in1 = 4'd2;
            mux_in2 = 4'd10;
            select = 1;
            reset_dut();
            repeat(12) @(posedge clk);
            #2;
            $display("Test Case 004: Mux2=10, Count=12");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            mux_in1 = 4'd0;
            select = 0;
            reset_dut();

            #2;
            $display("Test Case 005: Mux1=0, Count=0");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            mux_in1 = 4'd15;
            select = 0;
            reset_dut();
            repeat(14) @(posedge clk);
            #2;
            $display("Test Case 006: Mux1=15, Count=14");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            mux_in1 = 4'd15;
            select = 0;
            reset_dut();
            repeat(15) @(posedge clk);
            #2;
            $display("Test Case 007: Mux1=15, Count=15");
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
        testcase006();
        testcase007();
        
        
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
        input expected_pwm;
        begin
            if (expected_pwm === (expected_pwm ^ pwm ^ expected_pwm)) begin
                $display("PASS");
                $display("  Outputs: pwm=%b",
                         pwm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pwm=%b",
                         expected_pwm);
                $display("  Got:      pwm=%b",
                         pwm);
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
        $dumpvars(0,clk, mux_in1, mux_in2, reset, select, pwm);
    end

endmodule
