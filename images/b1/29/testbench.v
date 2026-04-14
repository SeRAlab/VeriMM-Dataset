`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] A;
    reg [1:0] B;
    reg clk;
    wire [3:0] P;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .P(P),
        .Q(Q)
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
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: A=0, B=0", test_num);
            A = 0; B = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: A=2, B=1", test_num);
            A = 2; B = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: A=3, B=2", test_num);
            A = 3; B = 2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: A=3, B=3", test_num);
            A = 3; B = 3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3, 4'd9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: A=0, B=3", test_num);
            A = 0; B = 3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: A=1, B=2", test_num);
            A = 1; B = 2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 4'd2);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test %0d: A=2, B=3", test_num);
            A = 2; B = 3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd2, 4'd6);
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
        input [3:0] expected_P;
        input [3:0] expected_Q;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: P=%h, Q=%h",
                         P, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h, Q=%h",
                         expected_P, expected_Q);
                $display("  Got:      P=%h, Q=%h",
                         P, Q);
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
        $dumpvars(0,A, B, clk, P, Q);
    end

endmodule
