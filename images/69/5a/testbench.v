`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] A;
    reg [1:0] B;
    reg clk;
    wire [3:0] Y0;
    wire [3:0] Y1;
    wire [3:0] Y2;
    wire [3:0] Y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .Y0(Y0),
        .Y1(Y1),
        .Y2(Y2),
        .Y3(Y3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 2'b00;
            B = 2'b00;

            repeat(3) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input A = 2'b00", test_num);
            reset_dut();

            A = 2'b00;
            B = 2'b00;


            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h1, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input A = 2'b01", test_num);
            reset_dut();

            A = 2'b01;
            B = 2'b00;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'h1, 4'h0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input A = 2'b10", test_num);
            reset_dut();

            A = 2'b10;
            B = 2'b00;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'h0, 4'h1, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input A = 2'b11", test_num);
            reset_dut();

            A = 2'b11;
            B = 2'b00;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'h0, 4'h0, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input A = 2'b10, B = 2'b11 (B ignored)", test_num);
            reset_dut();

            A = 2'b10;
            B = 2'b11;

            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 4'h0, 4'h1, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pipeline Sequence Test", test_num);
            reset_dut();


            A = 2'b01;
            @(posedge clk);

            A = 2'b11;
            @(posedge clk);

            A = 2'b00;
            #1;
            #1;

            check_outputs(4'h0, 4'h1, 4'h0, 4'h0);
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
        input [3:0] expected_Y0;
        input [3:0] expected_Y1;
        input [3:0] expected_Y2;
        input [3:0] expected_Y3;
        begin
            if (expected_Y0 === (expected_Y0 ^ Y0 ^ expected_Y0) &&
                expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1) &&
                expected_Y2 === (expected_Y2 ^ Y2 ^ expected_Y2) &&
                expected_Y3 === (expected_Y3 ^ Y3 ^ expected_Y3)) begin
                $display("PASS");
                $display("  Outputs: Y0=%h, Y1=%h, Y2=%h, Y3=%h",
                         Y0, Y1, Y2, Y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y0=%h, Y1=%h, Y2=%h, Y3=%h",
                         expected_Y0, expected_Y1, expected_Y2, expected_Y3);
                $display("  Got:      Y0=%h, Y1=%h, Y2=%h, Y3=%h",
                         Y0, Y1, Y2, Y3);
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
        $dumpvars(0,A, B, clk, Y0, Y1, Y2, Y3);
    end

endmodule
