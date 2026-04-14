`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [7:0] vector1;
    reg [7:0] vector2;
    wire [15:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .vector1(vector1),
        .vector2(vector2),
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
            vector1 = 0;
            vector2 = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            vector1 = 8'sd10;
            vector2 = 8'sd5;
            @(posedge clk);
            #1 #1;
 check_outputs(16'sd50);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            vector1 = 8'sd12;
            vector2 = -8'sd3;
            @(posedge clk);
            #1 #1;
 check_outputs(-16'sd36);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            vector1 = -8'sd7;
            vector2 = 8'sd9;
            @(posedge clk);
            #1 #1;
 check_outputs(-16'sd63);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            vector1 = -8'sd11;
            vector2 = -8'sd8;
            @(posedge clk);
            #1 #1;
 check_outputs(16'sd88);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            vector1 = 8'sd127;
            vector2 = 8'sd127;
            @(posedge clk);
            #1 #1;
 check_outputs(16'sd16129);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            vector1 = -8'sd128;
            vector2 = -8'sd128;
            @(posedge clk);
            #1 #1;
 check_outputs(16'sd16384);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            vector1 = -8'sd128;
            vector2 = 8'sd127;
            @(posedge clk);
            #1 #1;
 check_outputs(-16'sd16256);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            vector1 = 8'sd0;
            vector2 = -8'sd128;
            @(posedge clk);
            #1 #1;
 check_outputs(16'sd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            vector1 = 8'sd50;
            vector2 = 8'sd2;
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(16'sd0);
            rst = 0;
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            vector1 = 8'sd1;
            vector2 = -8'sd1;
            @(posedge clk);
            #1 #1;
 check_outputs(-16'sd1);
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
        input [15:0] expected_product;
        begin
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
        $dumpvars(0,clk, rst, vector1, vector2, product);
    end

endmodule
