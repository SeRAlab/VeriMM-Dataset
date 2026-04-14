`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg clk;
    reg enable;
    reg [1:0] op;
    reg reset;
    wire [31:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .enable(enable),
        .op(op),
        .reset(reset),
        .C(C)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            A = 0;
            B = 0;
            op = 0;
            #15;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (100 + 250)", test_num);
            reset_dut();
            @(negedge clk);
            A = 32'd100;
            B = 32'd250;
            op = 2'b00;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd350);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (500 - 150)", test_num);
            reset_dut();
            @(negedge clk);
            A = 32'd500;
            B = 32'd150;
            op = 2'b01;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd350);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiplication (12 * 11)", test_num);
            reset_dut();
            @(negedge clk);
            A = 32'd12;
            B = 32'd11;
            op = 2'b10;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd132);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division (1000 / 8)", test_num);
            reset_dut();
            @(negedge clk);
            A = 32'd1000;
            B = 32'd8;
            op = 2'b11;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd125);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable signal low (Output should remain reset value 0)", test_num);
            reset_dut();
            @(negedge clk);
            A = 32'hFFFF;
            B = 32'hFFFF;
            op = 2'b00;
            enable = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative result (10 - 50)", test_num);
            reset_dut();
            @(negedge clk);
            A = 32'd10;
            B = 32'd50;
            op = 2'b01;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd10 - 32'd50);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Division by zero (100 / 0)", test_num);
            reset_dut();
            @(negedge clk);
            A = 32'd100;
            B = 32'd0;
            op = 2'b11;
            enable = 1;
            @(posedge clk);
            #2;



            #1;




            check_outputs(32'd100 / 32'd0);
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
        input [31:0] expected_C;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
        $dumpvars(0,A, B, clk, enable, op, reset, C);
    end

endmodule
