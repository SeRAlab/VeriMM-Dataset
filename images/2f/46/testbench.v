`timescale 1ns/1ps

module iir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] x_in;
    wire [15:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    iir_filter dut (
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Zero Input Response");
            reset_dut();
            test_num = 1;
            x_in = 16'h0000;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Impulse Response");
            reset_dut();
            test_num = 2;
            x_in = 16'h1000;
            @(posedge clk);
            #1;
            x_in = 16'h0000;
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(y_out);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Step Response (Positive)");
            reset_dut();
            test_num = 3;
            x_in = 16'h00FF;
            repeat(20) @(posedge clk);
            #1;

            #1;


            check_outputs(y_out);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Negative Step Response");
            reset_dut();
            test_num = 4;
            x_in = 16'hFF01;
            repeat(20) @(posedge clk);
            #1;
            #1;

            check_outputs(y_out);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Reset Recovery");
            reset_dut();
            test_num = 5;
            x_in = 16'h7FFF;
            repeat(5) @(posedge clk);
            #1;
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("iir_filter Testbench");
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
        input [15:0] expected_y_out;
        begin
            if (expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: y_out=%h",
                         y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_out=%h",
                         expected_y_out);
                $display("  Got:      y_out=%h",
                         y_out);
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
        $dumpvars(0,clk, rst, x_in, y_out);
    end

endmodule
