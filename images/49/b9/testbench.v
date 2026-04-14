`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg ready;
    reg rst;
    reg [23:0] size;
    wire activate;
    wire strobe;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .ready(ready),
        .rst(rst),
        .size(size),
        .activate(activate),
        .strobe(strobe)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            ready = 0;
            size = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic operation size=5", test_num);
            reset_dut();

            size = 24'd5;
            enable = 1;
            ready = 1;

            @(posedge clk);
            #1;
            enable = 0;
            ready = 0;


            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary condition size=1", test_num);
            reset_dut();

            size = 24'd1;
            enable = 1;
            ready = 1;

            @(posedge clk);
            #1;


            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable without Ready", test_num);
            reset_dut();

            size = 24'd10;
            enable = 1;
            ready = 0;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mid-operation Reset", test_num);
            reset_dut();

            size = 24'd20;
            enable = 1;
            ready = 1;


            @(posedge clk);
            wait(activate == 1'b1);

            repeat(3) @(posedge clk);

            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Consecutive operations", test_num);
            reset_dut();


            size = 24'd2;
            enable = 1;
            ready = 1;
            @(posedge clk);
            #1 enable = 0; ready = 0;
            repeat(5) @(posedge clk);


            size = 24'd3;
            enable = 1;
            ready = 1;
            @(posedge clk);
            #1 enable = 0; ready = 0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Delayed Ready", test_num);
            reset_dut();

            size = 24'd4;
            enable = 1;
            ready = 0;
            repeat(3) @(posedge clk);

            #1 ready = 1;
            @(posedge clk);
            #1 enable = 0; ready = 0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_activate;
        input expected_strobe;
        begin
            if (expected_activate === (expected_activate ^ activate ^ expected_activate) &&
                expected_strobe === (expected_strobe ^ strobe ^ expected_strobe)) begin
                $display("PASS");
                $display("  Outputs: activate=%b, strobe=%b",
                         activate, strobe);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: activate=%b, strobe=%b",
                         expected_activate, expected_strobe);
                $display("  Got:      activate=%b, strobe=%b",
                         activate, strobe);
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
        $dumpvars(0,clk, enable, ready, rst, size, activate, strobe);
    end

endmodule
