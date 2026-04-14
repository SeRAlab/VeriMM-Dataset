`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] c_state;
    reg clk_div;
    reg rst;
    wire [4:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c_state(c_state),
        .clk_div(clk_div),
        .rst(rst),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk_div = 0;
        forever #5 clk_div = ~clk_div;
    end

        task reset_dut;

        begin
            rst = 1;
            c_state = 0;
            @(posedge clk_div);
            #1 rst = 0;
            @(posedge clk_div);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: State 0 Counting to 4", test_num);
            reset_dut();
            c_state = 3'd0;
            repeat(4) @(posedge clk_div);
            #1 #1;
 check_outputs(5'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: State 0 Wrap Around", test_num);
            reset_dut();
            c_state = 3'd0;
            repeat(5) @(posedge clk_div);
            #1 #1;
 check_outputs(5'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: State 3 Counting to 3", test_num);
            reset_dut();
            c_state = 3'd3;
            repeat(3) @(posedge clk_div);
            #1 #1;
 check_outputs(5'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: State 3 Wrap Around", test_num);
            reset_dut();
            c_state = 3'd3;
            repeat(5) @(posedge clk_div);
            #1 #1;
 check_outputs(5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: State 1 Max Count Check", test_num);
            reset_dut();
            c_state = 3'd1;
            repeat(1) @(posedge clk_div);
            #1 #1;
 check_outputs(5'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: State 1 Wrap Around", test_num);
            reset_dut();
            c_state = 3'd1;
            repeat(2) @(posedge clk_div);
            #1 #1;
 check_outputs(5'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: State 7 (Other) Max Count Check", test_num);
            reset_dut();
            c_state = 3'd7;
            repeat(1) @(posedge clk_div);
            #1 #1;
 check_outputs(5'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: State 7 (Other) Wrap Around", test_num);
            reset_dut();
            c_state = 3'd7;
            repeat(2) @(posedge clk_div);
            #1 #1;
 check_outputs(5'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %03d: Dynamic State Change Reset", test_num);
            reset_dut();
            c_state = 3'd0;
            repeat(3) @(posedge clk_div);
            #1 c_state = 3'd1;
            @(posedge clk_div);
            #1 #1;
 check_outputs(5'd0);
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
        input [4:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,c_state, clk_div, rst, count);
    end

endmodule
