`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] in0;
    reg [15:0] in1;
    reg rst;
    reg select;
    wire [15:0] count;
    wire [15:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in0(in0),
        .in1(in1),
        .rst(rst),
        .select(select),
        .count(count),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            select = 0;
            in0 = 0;
            in1 = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            select = 0;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            select = 1;
            in0 = 16'd12;
            in1 = 16'd5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 16'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            select = 1;
            in0 = 16'hFFFF;
            in1 = 16'h0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            select = 1;

            in0 = 16'h1000;
            in1 = 16'h0020;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            select = 0;
            repeat(5) @(posedge clk);


            select = 1;
            in0 = 16'd7;
            in1 = 16'd8;
            @(posedge clk);


            select = 0;
            repeat(2) @(posedge clk);

            #1;


            #1;



            check_outputs(16'd7, 16'd56);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            select = 1;
            in0 = 16'hFFFF;
            in1 = 16'h0002;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 16'hFFFE);
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
        input [15:0] expected_count;
        input [15:0] expected_product;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: count=%h, product=%h",
                         count, product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, product=%h",
                         expected_count, expected_product);
                $display("  Got:      count=%h, product=%h",
                         count, product);
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
        $dumpvars(0,clk, in0, in1, rst, select, count, product);
    end

endmodule
