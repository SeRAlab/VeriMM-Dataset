`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] req_0;
    reg [31:0] req_1;
    reg req_valid;
    reg res_ready;
    reg rst;
    wire req_ready;
    wire [31:0] res_0;
    wire res_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .req_0(req_0),
        .req_1(req_1),
        .req_valid(req_valid),
        .res_ready(res_ready),
        .rst(rst),
        .req_ready(req_ready),
        .res_0(res_0),
        .res_valid(res_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req_valid = 0;
            req_0 = 0;
            req_1 = 0;
            res_ready = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Addition (10 + 20)", test_num);


            while (!req_ready) @(posedge clk);


            req_0 = 32'd10;
            req_1 = 32'd20;
            req_valid = 1;
            @(posedge clk);
            req_valid = 0;


            while (!res_valid) @(posedge clk);


            #1;



            check_outputs(1'b0, 32'd30, 1'b1);


            res_ready = 1;
            @(posedge clk);
            res_ready = 0;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Addition (Max + 1)", test_num);

            while (!req_ready) @(posedge clk);

            req_0 = 32'hFFFFFFFF;
            req_1 = 32'h00000001;
            req_valid = 1;
            @(posedge clk);
            req_valid = 0;

            while (!res_valid) @(posedge clk);

            #1;


            check_outputs(1'b0, 32'h00000000, 1'b1);

            res_ready = 1;
            @(posedge clk);
            res_ready = 0;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Addition (0 + 0)", test_num);

            while (!req_ready) @(posedge clk);

            req_0 = 32'h0;
            req_1 = 32'h0;
            req_valid = 1;
            @(posedge clk);
            req_valid = 0;

            while (!res_valid) @(posedge clk);

            #1;


            check_outputs(1'b0, 32'h0, 1'b1);

            res_ready = 1;
            @(posedge clk);
            res_ready = 0;
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Hex Addition (0x12345678 + 0x11111111)", test_num);

            while (!req_ready) @(posedge clk);

            req_0 = 32'h12345678;
            req_1 = 32'h11111111;
            req_valid = 1;
            @(posedge clk);
            req_valid = 0;

            while (!res_valid) @(posedge clk);

            #1;


            check_outputs(1'b0, 32'h23456789, 1'b1);

            res_ready = 1;
            @(posedge clk);
            res_ready = 0;
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Bit Pattern Addition (0xAAAAAAAA + 0x55555555)", test_num);

            while (!req_ready) @(posedge clk);

            req_0 = 32'hAAAAAAAA;
            req_1 = 32'h55555555;
            req_valid = 1;
            @(posedge clk);
            req_valid = 0;

            while (!res_valid) @(posedge clk);

            #1;


            check_outputs(1'b0, 32'hFFFFFFFF, 1'b1);

            res_ready = 1;
            @(posedge clk);
            res_ready = 0;
            @(posedge clk);
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
        input expected_req_ready;
        input [31:0] expected_res_0;
        input expected_res_valid;
        begin
            if (expected_req_ready === (expected_req_ready ^ req_ready ^ expected_req_ready) &&
                expected_res_0 === (expected_res_0 ^ res_0 ^ expected_res_0) &&
                expected_res_valid === (expected_res_valid ^ res_valid ^ expected_res_valid)) begin
                $display("PASS");
                $display("  Outputs: req_ready=%b, res_0=%h, res_valid=%b",
                         req_ready, res_0, res_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: req_ready=%b, res_0=%h, res_valid=%b",
                         expected_req_ready, expected_res_0, expected_res_valid);
                $display("  Got:      req_ready=%b, res_0=%h, res_valid=%b",
                         req_ready, res_0, res_valid);
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
        $dumpvars(0,clk, req_0, req_1, req_valid, res_ready, rst, req_ready, res_0, res_valid);
    end

endmodule
