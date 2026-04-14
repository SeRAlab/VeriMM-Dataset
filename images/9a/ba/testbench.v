`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] E;
    reg clk;
    wire [7:0] D;
    wire [7:0] F;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .E(E),
        .clk(clk),
        .D(D),
        .F(F)
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
            C = 0;
            E = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            A = 4'd0; B = 4'd0; C = 4'd0; E = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition", test_num);
            reset_dut();
            A = 4'd1; B = 4'd2; C = 4'd3; E = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd6, 8'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Input Values", test_num);
            reset_dut();
            A = 4'hF; B = 4'hF; C = 4'hF; E = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd45, 8'd45);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Different C and E", test_num);
            reset_dut();
            A = 4'd5; B = 4'd5; C = 4'd0; E = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd10, 8'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Crossing 16", test_num);
            reset_dut();
            A = 4'd8; B = 4'd8; C = 4'd1; E = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd17, 8'd16);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Prime Combination", test_num);
            reset_dut();
            A = 4'd7; B = 4'd11; C = 4'd13; E = 4'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd31, 8'd20);
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
        input [7:0] expected_D;
        input [7:0] expected_F;
        begin
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_F === (expected_F ^ F ^ expected_F)) begin
                $display("PASS");
                $display("  Outputs: D=%h, F=%h",
                         D, F);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h, F=%h",
                         expected_D, expected_F);
                $display("  Got:      D=%h, F=%h",
                         D, F);
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
        $dumpvars(0,A, B, C, E, clk, D, F);
    end

endmodule
