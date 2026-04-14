`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] M;
    reg [3:0] N;
    reg clk;
    wire E;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M(M),
        .N(N),
        .clk(clk),
        .E(E),
        .P(P)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            M = 0;
            N = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 0 x 0", test_num);
            M = 4'd0;
            N = 4'd0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 1 x 1", test_num);
            M = 4'd1;
            N = 4'd1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 8'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 15 x 15 (Max)", test_num);
            M = 4'd15;
            N = 4'd15;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd225);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 12 x 10", test_num);
            M = 4'd12;
            N = 4'd10;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 8'd120);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 15 x 8", test_num);
            M = 4'd15;
            N = 4'd8;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 8'd120);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 15 x 9 (Overflow Check)", test_num);
            M = 4'd15;
            N = 4'd9;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1, 8'd135);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 10 x 1", test_num);
            M = 4'd10;
            N = 4'd1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0, 8'd10);
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
        input expected_E;
        input [7:0] expected_P;
        begin
            if (expected_E === (expected_E ^ E ^ expected_E) &&
                expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: E=%b, P=%h",
                         E, P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: E=%b, P=%h",
                         expected_E, expected_P);
                $display("  Got:      E=%b, P=%h",
                         E, P);
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
        $dumpvars(0,M, N, clk, E, P);
    end

endmodule
