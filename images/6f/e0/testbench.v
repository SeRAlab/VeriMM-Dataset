`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg caculating_start;
    reg clk;
    reg res_done;
    reg reset;
    reg [31:0] value0;
    reg [31:0] value1;
    reg [31:0] value2;
    reg [31:0] value3;
    reg [31:0] value4;
    reg [31:0] value5;
    reg [31:0] value6;
    reg [31:0] value7;
    reg [31:0] value8;
    wire caculating_done;
    wire [31:0] ret;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .caculating_start(caculating_start),
        .clk(clk),
        .res_done(res_done),
        .reset(reset),
        .value0(value0),
        .value1(value1),
        .value2(value2),
        .value3(value3),
        .value4(value4),
        .value5(value5),
        .value6(value6),
        .value7(value7),
        .value8(value8),
        .caculating_done(caculating_done),
        .ret(ret)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            caculating_start = 0;
            res_done = 0;
            value0 = 0; value1 = 0; value2 = 0;
            value3 = 0; value4 = 0; value5 = 0;
            value6 = 0; value7 = 0; value8 = 0;
            #20;
            reset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Summing all 1s", test_num);
            reset_dut();

            value0 = 32'd1; value1 = 32'd1; value2 = 32'd1;
            value3 = 32'd1; value4 = 32'd1; value5 = 32'd1;
            value6 = 32'd1; value7 = 32'd1; value8 = 32'd1;

            @(posedge clk);
            caculating_start = 1;
            @(posedge clk);
            caculating_start = 0;


            wait(caculating_done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 32'd9);


            res_done = 1;
            @(posedge clk);
            res_done = 0;
            #10;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            reset_dut();

            value0 = 32'd0; value1 = 32'd0; value2 = 32'd0;
            value3 = 32'd0; value4 = 32'd0; value5 = 32'd0;
            value6 = 32'd0; value7 = 32'd0; value8 = 32'd0;

            @(posedge clk);
            caculating_start = 1;
            @(posedge clk);
            caculating_start = 0;

            wait(caculating_done == 1);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 32'd0);

            res_done = 1;
            @(posedge clk);
            res_done = 0;
            #10;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Summing 1 through 9", test_num);
            reset_dut();

            value0 = 32'd1; value1 = 32'd2; value2 = 32'd3;
            value3 = 32'd4; value4 = 32'd5; value5 = 32'd6;
            value6 = 32'd7; value7 = 32'd8; value8 = 32'd9;

            @(posedge clk);
            caculating_start = 1;
            @(posedge clk);
            caculating_start = 0;

            wait(caculating_done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 32'd45);

            res_done = 1;
            @(posedge clk);
            res_done = 0;
            #10;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Summing large values", test_num);
            reset_dut();

            value0 = 32'h10000000; value1 = 32'h10000000; value2 = 32'h10000000;
            value3 = 32'h10000000; value4 = 32'h10000000; value5 = 32'h10000000;
            value6 = 32'h10000000; value7 = 32'h10000000; value8 = 32'h10000000;

            @(posedge clk);
            caculating_start = 1;
            @(posedge clk);
            caculating_start = 0;

            wait(caculating_done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 32'h90000000);

            res_done = 1;
            @(posedge clk);
            res_done = 0;
            #10;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Summing powers of 2", test_num);
            reset_dut();

            value0 = 32'd1;   value1 = 32'd2;   value2 = 32'd4;
            value3 = 32'd8;   value4 = 32'd16;  value5 = 32'd32;
            value6 = 32'd64;  value7 = 32'd128; value8 = 32'd256;

            @(posedge clk);
            caculating_start = 1;
            @(posedge clk);
            caculating_start = 0;

            wait(caculating_done == 1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 32'd511);

            res_done = 1;
            @(posedge clk);
            res_done = 0;
            #10;
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
        input expected_caculating_done;
        input [31:0] expected_ret;
        begin
            if (expected_caculating_done === (expected_caculating_done ^ caculating_done ^ expected_caculating_done) &&
                expected_ret === (expected_ret ^ ret ^ expected_ret)) begin
                $display("PASS");
                $display("  Outputs: caculating_done=%b, ret=%h",
                         caculating_done, ret);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: caculating_done=%b, ret=%h",
                         expected_caculating_done, expected_ret);
                $display("  Got:      caculating_done=%b, ret=%h",
                         caculating_done, ret);
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
        $dumpvars(0,caculating_start, clk, res_done, reset, value0, value1, value2, value3, value4, value5, value6, value7, value8, caculating_done, ret);
    end

endmodule
