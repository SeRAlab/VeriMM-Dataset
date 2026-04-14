`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .P(P)
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
    task run_test;

        input signed [3:0] val_a;
        input signed [3:0] val_b;
        input signed [7:0] expected_p;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=%d, B=%d", test_num, val_a, val_b);
            reset_dut();
            A = val_a;
            B = val_b;


            repeat(10) @(posedge clk);
            #1;

            check_outputs(expected_p);
        end
        endtask

    task testcase001;

        run_test(4'd0, 4'd0, 8'd0);
        endtask

    task testcase002;

        run_test(4'd2, 4'd3, 8'd6);
        endtask

    task testcase003;

        run_test(4'd7, 4'd7, 8'd49);
        endtask

    task testcase004;

        run_test(-4'sd8, 4'sd7, -8'sd56);
        endtask

    task testcase005;

        run_test(4'sd7, -4'sd8, -8'sd56);
        endtask

    task testcase006;

        run_test(-4'sd8, -4'sd8, 8'sd64);
        endtask

    task testcase007;

        run_test(-4'sd1, 4'sd5, -8'sd5);
        endtask

    task testcase008;

        run_test(4'sd5, -4'sd1, -8'sd5);
        endtask

    task testcase009;

        run_test(-4'sd1, -4'sd1, 8'sd1);
        endtask

    task testcase010;

        run_test(-4'sd4, 4'sd3, -8'sd12);
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
        input [7:0] expected_P;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
        $dumpvars(0,A, B, clk, P);
    end

endmodule
