`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg [7:0] divisor;
    reg rst;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .divisor(divisor),
        .rst(rst),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            rst = 1;

            @(posedge clk_in);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            divisor = 8'd1;
            reset_dut();
            repeat(2) @(posedge clk_in);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            divisor = 8'd1;
            reset_dut();
            repeat(4) @(posedge clk_in);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            divisor = 8'd2;
            reset_dut();
            repeat(3) @(posedge clk_in);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            divisor = 8'd2;
            reset_dut();
            repeat(6) @(posedge clk_in);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            divisor = 8'd0;
            reset_dut();
            repeat(1) @(posedge clk_in);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            divisor = 8'd10;
            reset_dut();
            repeat(11) @(posedge clk_in);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            divisor = 8'd255;
            reset_dut();
            repeat(256) @(posedge clk_in);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            divisor = 8'd50;
            reset_dut();
            #1 #1;
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
        input expected_clk_out;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b",
                         clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b",
                         expected_clk_out);
                $display("  Got:      clk_out=%b",
                         clk_out);
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
        $dumpvars(0,clk_in, divisor, rst, clk_out);
    end

endmodule
