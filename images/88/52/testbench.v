`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in;
    reg [3:0] shift_amount;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .shift_amount(shift_amount),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 16'h0000;
            shift_amount = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            in = 16'h1234;
            shift_amount = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            in = 16'h1234;
            shift_amount = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h2341);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            in = 16'hABCD;
            shift_amount = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hCDAB);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            in = 16'h1234;
            shift_amount = 4'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h4123);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            in = 16'h8000;
            shift_amount = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            in = 16'h0001;
            shift_amount = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            in = 16'h0000;
            shift_amount = 4'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            in = 16'hFFFF;
            shift_amount = 4'd11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            in = 16'h5555;
            shift_amount = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            in = 16'hC000;
            shift_amount = 4'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0003);
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
        input [15:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, shift_amount, out);
    end

endmodule
