`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd0;
            B = 4'd0;
            repeat(8) @(posedge clk);
            $display("Testcase %0d: A=0, B=0", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd15;
            B = 4'd15;
            repeat(8) @(posedge clk);
            $display("Testcase %0d: A=15, B=15", test_num);
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd1;
            B = 4'd10;
            repeat(8) @(posedge clk);
            $display("Testcase %0d: A=1, B=10", test_num);
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd12;
            B = 4'd0;
            repeat(8) @(posedge clk);
            $display("Testcase %0d: A=12, B=0", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd3;
            B = 4'd7;
            repeat(8) @(posedge clk);
            $display("Testcase %0d: A=3, B=7", test_num);
            #1;

            check_outputs(8'd21);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd13;
            B = 4'd11;
            repeat(8) @(posedge clk);
            $display("Testcase %0d: A=13, B=11", test_num);
            #1;

            check_outputs(8'd143);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd4;
            B = 4'd8;
            repeat(8) @(posedge clk);
            $display("Testcase %0d: A=4, B=8", test_num);
            #1;

            check_outputs(8'd32);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd9;
            B = 4'd14;
            repeat(8) @(posedge clk);
            $display("Testcase %0d: A=9, B=14", test_num);
            #1;

            check_outputs(8'd126);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd5;
            B = 4'd6;
            repeat(8) @(posedge clk);
            $display("Testcase %0d: A=5, B=6", test_num);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            A = 4'd6;
            B = 4'd5;
            repeat(8) @(posedge clk);
            $display("Testcase %0d: A=6, B=5", test_num);
            #1;

            check_outputs(8'd30);
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
        input [7:0] expected_product;
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
        $dumpvars(0,A, B, clk, product);
    end

endmodule
