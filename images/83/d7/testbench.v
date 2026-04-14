`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg carry_in;
    reg clk;
    reg [7:0] x;
    reg [7:0] y;
    wire carry_output_bit;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .carry_in(carry_in),
        .clk(clk),
        .x(x),
        .y(y),
        .carry_output_bit(carry_output_bit),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            x <= 8'd0;
            y <= 8'd0;
            carry_in <= 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 5 + 10 + 0", test_num);
            reset_dut();
            x <= 8'h05;
            y <= 8'h0A;
            carry_in <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h0F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 20 + 30 + 1", test_num);
            reset_dut();
            x <= 8'd20;
            y <= 8'd30;
            carry_in <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'd51);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 200 + 100 + 0", test_num);
            reset_dut();
            x <= 8'd200;
            y <= 8'd100;
            carry_in <= 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h2C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 255 + 255 + 1", test_num);
            reset_dut();
            x <= 8'hFF;
            y <= 8'hFF;
            carry_in <= 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 0 + 0 + 1", test_num);
            reset_dut();
            x <= 8'h00;
            y <= 8'h00;
            carry_in <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 128 + 128 + 0", test_num);
            reset_dut();
            x <= 8'd128;
            y <= 8'd128;
            carry_in <= 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 127 + 128 + 0", test_num);
            reset_dut();
            x <= 8'd127;
            y <= 8'd128;
            carry_in <= 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'hFF);
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
        input expected_carry_output_bit;
        input [7:0] expected_sum;
        begin
            if (expected_carry_output_bit === (expected_carry_output_bit ^ carry_output_bit ^ expected_carry_output_bit) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry_output_bit=%b, sum=%h",
                         carry_output_bit, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_output_bit=%b, sum=%h",
                         expected_carry_output_bit, expected_sum);
                $display("  Got:      carry_output_bit=%b, sum=%h",
                         carry_output_bit, sum);
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
        $dumpvars(0,carry_in, clk, x, y, carry_output_bit, sum);
    end

endmodule
