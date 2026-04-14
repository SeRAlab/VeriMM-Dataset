`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] d;
    reg enable;
    reg reset;
    wire [3:0] counter_q;
    wire [3:0] q;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .enable(enable),
        .reset(reset),
        .counter_q(counter_q),
        .q(q),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            d = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset state", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0, 4'h0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter increment (Enable=0)", test_num);
            reset_dut();
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h5, 4'h0, 8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift register operation", test_num);
            reset_dut();
            enable = 1;
            d = 4'b0001;
            repeat (4) @(posedge clk);
            #1;
            enable = 0;

            #1;


            check_outputs(4'h4, 4'hF, 8'hF4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter overflow check", test_num);
            reset_dut();
            repeat (16) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'h0, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mixed shift and count", test_num);
            reset_dut();


            enable = 1; d = 4'b0001;
            repeat (2) @(posedge clk);


            enable = 0;
            repeat (2) @(posedge clk);


            enable = 1; d = 4'b0000;
            repeat (2) @(posedge clk);


            enable = 0;
            repeat (2) @(posedge clk);

            #1;

            #1;


            check_outputs(4'h8, 4'hC, 8'hC8);
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
        input [3:0] expected_counter_q;
        input [3:0] expected_q;
        input [7:0] expected_sum;
        begin
            if (expected_counter_q === (expected_counter_q ^ counter_q ^ expected_counter_q) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: counter_q=%h, q=%h, sum=%h",
                         counter_q, q, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_q=%h, q=%h, sum=%h",
                         expected_counter_q, expected_q, expected_sum);
                $display("  Got:      counter_q=%h, q=%h, sum=%h",
                         counter_q, q, sum);
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
        $dumpvars(0,clk, d, enable, reset, counter_q, q, sum);
    end

endmodule
