`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in0;
    reg [3:0] in1;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in0 = 4'd0;
            in1 = 4'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            in0 = 4'd0;
            in1 = 4'd0;
            @(posedge clk);
            #1;
            $display("Test %0d: in0=%d, in1=%d", test_num, in0, in1);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            in0 = 4'd3;
            in1 = 4'd7;
            @(posedge clk);
            #1;
            $display("Test %0d: in0=%d, in1=%d", test_num, in0, in1);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            in0 = 4'd12;
            in1 = 4'd4;
            @(posedge clk);
            #1;
            $display("Test %0d: in0=%d, in1=%d", test_num, in0, in1);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            in0 = 4'd15;
            in1 = 4'd15;
            @(posedge clk);
            #1;
            $display("Test %0d: in0=%d, in1=%d", test_num, in0, in1);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            in0 = 4'd15;
            in1 = 4'd0;
            @(posedge clk);
            #1;
            $display("Test %0d: in0=%d, in1=%d", test_num, in0, in1);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            in0 = 4'd0;
            in1 = 4'd15;
            @(posedge clk);
            #1;
            $display("Test %0d: in0=%d, in1=%d", test_num, in0, in1);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            in0 = 4'd8;
            in1 = 4'd7;
            @(posedge clk);
            #1;
            $display("Test %0d: in0=%d, in1=%d", test_num, in0, in1);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            in0 = 4'd7;
            in1 = 4'd8;
            @(posedge clk);
            #1;
            $display("Test %0d: in0=%d, in1=%d", test_num, in0, in1);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            in0 = 4'd9;
            in1 = 4'd9;
            @(posedge clk);
            #1;
            $display("Test %0d: in0=%d, in1=%d", test_num, in0, in1);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            in0 = 4'b1010;
            in1 = 4'b0101;
            @(posedge clk);
            #1;
            $display("Test %0d: in0=%b, in1=%b", test_num, in0, in1);
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_out;
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
        $dumpvars(0,clk, in0, in1, out);
    end

endmodule
