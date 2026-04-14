`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg clk;
    reg load;
    wire [3:0] Q;

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
        .load(load),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        A = 4'h0;
        B = 4'h0;
        C = 4'h0;
        D = 4'h0;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        A = 4'h1; B = 4'h2; C = 4'h3; D = 4'h4;
        load = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'h1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        A = 4'h5; B = 4'hA; C = 4'hE; D = 4'hF;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        A = 4'h1; B = 4'h2; C = 4'h3; D = 4'h4;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(4'h3);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        A = 4'h8; B = 4'h4; C = 4'h2; D = 4'h1;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        repeat(3) @(posedge clk);
        #1;

        #1;


        check_outputs(4'h1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        A = 4'hC; B = 4'hD; C = 4'hE; D = 4'hF;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        repeat(4) @(posedge clk);
        #1;

        #1;


        check_outputs(4'hC);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        A = 4'h2; B = 4'h4; C = 4'h6; D = 4'h8;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        A = 4'hF; B = 4'hF; C = 4'hF; D = 4'hF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'h4);
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,A, B, C, D, clk, load, Q);
    end

endmodule
