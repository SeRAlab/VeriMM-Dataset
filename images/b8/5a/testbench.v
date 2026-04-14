`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg clk;
    wire A;
    wire B;
    wire C;
    wire D_out;
    wire E;
    wire F;
    wire G;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .clk(clk),
        .A(A),
        .B(B),
        .C(C),
        .D_out(D_out),
        .E(E),
        .F(F),
        .G(G)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        D = 4'b0000;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase000;

    begin
        test_num = 0;
        reset_dut();
        D = 4'h0;
        @(posedge clk);
        #2;
        $display("Test Case 000: D=0");
        #1;

        check_outputs(1, 1, 1, 1, 1, 1, 0);
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        D = 4'h1;
        @(posedge clk);
        #2;
        $display("Test Case 001: D=1");
        #1;

        check_outputs(0, 1, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        D = 4'h2;
        @(posedge clk);
        #2;
        $display("Test Case 002: D=2");
        #1;

        check_outputs(1, 1, 0, 1, 1, 0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        D = 4'h3;
        @(posedge clk);
        #2;
        $display("Test Case 003: D=3");
        #1;

        check_outputs(1, 1, 1, 1, 0, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        D = 4'h4;
        @(posedge clk);
        #2;
        $display("Test Case 004: D=4");
        #1;

        check_outputs(0, 1, 1, 0, 0, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        D = 4'h5;
        @(posedge clk);
        #2;
        $display("Test Case 005: D=5");
        #1;

        check_outputs(1, 0, 1, 1, 0, 1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        D = 4'h6;
        @(posedge clk);
        #2;
        $display("Test Case 006: D=6");
        #1;

        check_outputs(1, 0, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        D = 4'h7;
        @(posedge clk);
        #2;
        $display("Test Case 007: D=7");
        #1;

        check_outputs(1, 1, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        D = 4'h8;
        @(posedge clk);
        #2;
        $display("Test Case 008: D=8");
        #1;

        check_outputs(1, 1, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_dut();
        D = 4'h9;
        @(posedge clk);
        #2;
        $display("Test Case 009: D=9");
        #1;

        check_outputs(1, 1, 1, 1, 0, 1, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        reset_dut();
        D = 4'hA;
        @(posedge clk);
        #2;
        $display("Test Case 010: D=A");
        #1;

        check_outputs(1, 1, 1, 0, 1, 1, 1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        reset_dut();
        D = 4'hB;
        @(posedge clk);
        #2;
        $display("Test Case 011: D=B");
        #1;

        check_outputs(0, 0, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        reset_dut();
        D = 4'hC;
        @(posedge clk);
        #2;
        $display("Test Case 012: D=C");
        #1;

        check_outputs(1, 0, 0, 1, 1, 1, 0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        reset_dut();
        D = 4'hD;
        @(posedge clk);
        #2;
        $display("Test Case 013: D=D");
        #1;

        check_outputs(0, 1, 1, 1, 1, 0, 1);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        reset_dut();
        D = 4'hE;
        @(posedge clk);
        #2;
        $display("Test Case 014: D=E");
        #1;

        check_outputs(1, 0, 0, 1, 1, 1, 1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        reset_dut();
        D = 4'hF;
        @(posedge clk);
        #2;
        $display("Test Case 015: D=F");
        #1;

        check_outputs(1, 0, 0, 0, 1, 1, 1);
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


        testcase000();
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input expected_A;
        input expected_B;
        input expected_C;
        input expected_D_out;
        input expected_E;
        input expected_F;
        input expected_G;
        begin
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_B === (expected_B ^ B ^ expected_B) &&
                expected_C === (expected_C ^ C ^ expected_C) &&
                expected_D_out === (expected_D_out ^ D_out ^ expected_D_out) &&
                expected_E === (expected_E ^ E ^ expected_E) &&
                expected_F === (expected_F ^ F ^ expected_F) &&
                expected_G === (expected_G ^ G ^ expected_G)) begin
                $display("PASS");
                $display("  Outputs: A=%b, B=%b, C=%b, D_out=%b, E=%b, F=%b, G=%b",
                         A, B, C, D_out, E, F, G);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%b, B=%b, C=%b, D_out=%b, E=%b, F=%b, G=%b",
                         expected_A, expected_B, expected_C, expected_D_out, expected_E, expected_F, expected_G);
                $display("  Got:      A=%b, B=%b, C=%b, D_out=%b, E=%b, F=%b, G=%b",
                         A, B, C, D_out, E, F, G);
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
        $dumpvars(0,D, clk, A, B, C, D_out, E, F, G);
    end

endmodule
