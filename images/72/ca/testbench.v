`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg reset;
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
        .reset(reset),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0;
            B = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: A == B (4, 4)", test_num);
            reset_dut();
            A = 4'd4; B = 4'd4;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd16);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: A == B (15, 15)", test_num);
            reset_dut();
            A = 4'd15; B = 4'd15;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd225);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: A == B (0, 0)", test_num);
            reset_dut();
            A = 4'd0; B = 4'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: A > B (10, 5)", test_num);
            reset_dut();
            A = 4'd10; B = 4'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: A > B (15, 0)", test_num);
            reset_dut();
            A = 4'd15; B = 4'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: A < B (5, 10)", test_num);
            reset_dut();
            A = 4'd5; B = 4'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: A < B (0, 15)", test_num);
            reset_dut();
            A = 4'd0; B = 4'd15;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset verification", test_num);
            A = 4'd7; B = 4'd7;
            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0);
            reset = 0;
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
        $dumpvars(0,A, B, clk, reset, product);
    end

endmodule
