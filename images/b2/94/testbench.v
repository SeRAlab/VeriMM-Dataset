`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg clk;
    wire Y0;
    wire Y1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .clk(clk),
        .Y0(Y0),
        .Y1(Y1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'b0000;
            B = 4'b0000;
            C = 4'b0000;
            D = 4'b0000;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: A[3] is set, others 0. Expect A (Y1=0, Y0=0)", test_num);
            A = 4'b1000; B = 4'b0000; C = 4'b0000; D = 4'b0000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: B[3] is set, others 0. Expect B (Y1=0, Y0=1)", test_num);
            A = 4'b0000; B = 4'b1000; C = 4'b0000; D = 4'b0000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: C[3] is set, others 0. Expect C (Y1=1, Y0=0)", test_num);
            A = 4'b0000; B = 4'b0000; C = 4'b1000; D = 4'b0000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: D[3] is set, others 0. Expect D (Y1=1, Y0=1)", test_num);
            A = 4'b0000; B = 4'b0000; C = 4'b0000; D = 4'b1000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: A[3] and B[3] set. Expect A (Y1=0, Y0=0)", test_num);
            A = 4'b1000; B = 4'b1000; C = 4'b0000; D = 4'b0000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: D[3] and A[2] set. Expect D (Y1=1, Y0=1)", test_num);
            A = 4'b0100; B = 4'b0000; C = 4'b0000; D = 4'b1000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 3 is 0, B[2] and C[2] set. Expect B (Y1=0, Y0=1)", test_num);
            A = 4'b0000; B = 4'b0100; C = 4'b0100; D = 4'b0000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Only A[0] is set. Expect A (Y1=0, Y0=0)", test_num);
            A = 4'b0001; B = 4'b0000; C = 4'b0000; D = 4'b0000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: C[1] and A[0] set. Expect C (Y1=1, Y0=0)", test_num);
            A = 4'b0001; B = 4'b0000; C = 4'b0010; D = 4'b0000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: A=0001, B=0010, C=0100, D=0000. Expect C (Y1=1, Y0=0)", test_num);
            A = 4'b0001; B = 4'b0010; C = 4'b0100; D = 4'b0000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_Y0;
        input expected_Y1;
        begin
            if (expected_Y0 === (expected_Y0 ^ Y0 ^ expected_Y0) &&
                expected_Y1 === (expected_Y1 ^ Y1 ^ expected_Y1)) begin
                $display("PASS");
                $display("  Outputs: Y0=%b, Y1=%b",
                         Y0, Y1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y0=%b, Y1=%b",
                         expected_Y0, expected_Y1);
                $display("  Got:      Y0=%b, Y1=%b",
                         Y0, Y1);
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
        $dumpvars(0,A, B, C, D, clk, Y0, Y1);
    end

endmodule
