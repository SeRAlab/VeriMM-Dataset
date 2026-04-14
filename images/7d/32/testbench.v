`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] divisor;
    wire div_clk;
    wire [7:0] div_cnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .divisor(divisor),
        .div_clk(div_clk),
        .div_cnt(div_cnt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            divisor = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Divisor = 2, wait 2 cycles", test_num);
            reset_dut();
            divisor = 8'd2;


            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Divisor = 2, wait 4 cycles", test_num);
            reset_dut();
            divisor = 8'd2;

            repeat(4) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Divisor = 10, wait 5 cycles", test_num);
            reset_dut();
            divisor = 8'd10;

            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Divisor = 10, wait 10 cycles", test_num);
            reset_dut();
            divisor = 8'd10;

            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Divisor = 1, wait 1 cycle", test_num);
            reset_dut();
            divisor = 8'd1;

            repeat(1) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %03d: Divisor = 1, wait 2 cycles", test_num);
            reset_dut();
            divisor = 8'd1;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'd0);
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
        input expected_div_clk;
        input [7:0] expected_div_cnt;
        begin
            if (expected_div_clk === (expected_div_clk ^ div_clk ^ expected_div_clk) &&
                expected_div_cnt === (expected_div_cnt ^ div_cnt ^ expected_div_cnt)) begin
                $display("PASS");
                $display("  Outputs: div_clk=%b, div_cnt=%h",
                         div_clk, div_cnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: div_clk=%b, div_cnt=%h",
                         expected_div_clk, expected_div_cnt);
                $display("  Got:      div_clk=%b, div_cnt=%h",
                         div_clk, div_cnt);
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
        $dumpvars(0,clk, divisor, div_clk, div_cnt);
    end

endmodule
