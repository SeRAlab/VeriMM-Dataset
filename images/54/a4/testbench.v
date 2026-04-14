`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] din;
    reg new_data_rdy;
    wire [27:0] dout;
    wire output_data_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .new_data_rdy(new_data_rdy),
        .dout(dout),
        .output_data_ready(output_data_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            new_data_rdy = 0;
            din = 0;
            repeat(5) @(posedge clk);

            repeat(8) begin
                @(negedge clk);
                new_data_rdy = 1;
                din = 16'sd0;
                @(negedge clk);
                new_data_rdy = 0;
            end
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All Zeros", test_num);
            reset_dut();

            repeat(3) begin
                @(negedge clk);
                new_data_rdy = 1; din = 16'sd0;
                @(negedge clk);
                new_data_rdy = 0;
            end

            wait(output_data_ready);
            #1;

            check_outputs(28'sd0, 1'b1);
        end
        endtask

    task testcase002;

        signed [27:0] expected;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Impulse Response (Tail tap)", test_num);
            reset_dut();


            @(negedge clk);
            new_data_rdy = 1; din = 16'sd1;
            @(negedge clk);
            new_data_rdy = 0;


            repeat(6) begin
                @(negedge clk);
                new_data_rdy = 1; din = 16'sd0;
                @(negedge clk);
                new_data_rdy = 0;
            end

            wait(output_data_ready);
            expected = 1 * C6;
            #1;

            check_outputs(expected, 1'b1);
        end
        endtask

    task testcase003;

        signed [27:0] coeff_sum;
        signed [27:0] expected;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Positive DC Gain", test_num);
            reset_dut();

            coeff_sum = C0 + C1 + C2 + C3 + C4 + C5 + C6;
            expected = 10 * coeff_sum;

            repeat(7) begin
                @(negedge clk);
                new_data_rdy = 1; din = 16'sd10;
                @(negedge clk);
                new_data_rdy = 0;
            end

            wait(output_data_ready);
            #1;

            check_outputs(expected, 1'b1);
        end
        endtask

    task testcase004;

        signed [27:0] coeff_sum;
        signed [27:0] expected;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Negative DC Gain", test_num);
            reset_dut();

            coeff_sum = C0 + C1 + C2 + C3 + C4 + C5 + C6;
            expected = -16'sd5 * coeff_sum;

            repeat(7) begin
                @(negedge clk);
                new_data_rdy = 1; din = -16'sd5;
                @(negedge clk);
                new_data_rdy = 0;
            end

            wait(output_data_ready);
            #1;

            check_outputs(expected, 1'b1);
        end
        endtask

    task testcase005;

        signed [27:0] coeff_sum;
        signed [27:0] expected;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Full Scale Input", test_num);
            reset_dut();

            coeff_sum = C0 + C1 + C2 + C3 + C4 + C5 + C6;
            expected = 16'sh7FFF * coeff_sum;

            repeat(7) begin
                @(negedge clk);
                new_data_rdy = 1; din = 16'sh7FFF;
                @(negedge clk);
                new_data_rdy = 0;
            end

            wait(output_data_ready);
            #1;

            check_outputs(expected, 1'b1);
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
        input [27:0] expected_dout;
        input expected_output_data_ready;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_output_data_ready === (expected_output_data_ready ^ output_data_ready ^ expected_output_data_ready)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, output_data_ready=%b",
                         dout, output_data_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, output_data_ready=%b",
                         expected_dout, expected_output_data_ready);
                $display("  Got:      dout=%h, output_data_ready=%b",
                         dout, output_data_ready);
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
        $dumpvars(0,clk, din, new_data_rdy, dout, output_data_ready);
    end

endmodule
