`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] A;
    reg [2:0] B;
    reg CLK;
    reg RST;
    wire [2:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .RST(RST),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            A = 3'b000;
            B = 3'b000;
            @(posedge CLK);
            #1;
            RST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition (1 + 2)", test_num);
            reset_dut();
            @(negedge CLK);
            A = 3'd1;
            B = 3'd2;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Addition (3 + 4 = 7)", test_num);
            reset_dut();
            @(negedge CLK);
            A = 3'd3;
            B = 3'd4;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Case (4 + 4 = 0 mod 8)", test_num);
            reset_dut();
            @(negedge CLK);
            A = 3'd4;
            B = 3'd4;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zeros Addition (0 + 0)", test_num);
            reset_dut();
            @(negedge CLK);
            A = 3'd0;
            B = 3'd0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Overflow (7 + 7 = 6 mod 8)", test_num);
            reset_dut();
            @(negedge CLK);
            A = 3'd7;
            B = 3'd7;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Reset override", test_num);
            reset_dut();
            @(negedge CLK);
            A = 3'd2;
            B = 3'd2;
            RST = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(3'd0);
            RST = 0;
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
        input [2:0] expected_Q;
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
        $dumpvars(0,A, B, CLK, RST, Q);
    end

endmodule
