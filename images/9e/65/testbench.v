`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg C;
    reg [3:0] S;
    wire [15:0] B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .C(C),
        .S(S),
        .B(B)
    );

    // Clock generation (10ns period)
    initial begin
        C = 0;
        forever #5 C = ~C;
    end

        task reset_dut;

        begin
            A = 0;
            S = 0;
            @(posedge C);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            A = 16'h0001; S = 4;
            @(posedge C);
            @(negedge C);
            #2;
            $display("Test %0d: Left Shift 16'h0001 by 4 (C=0)", test_num);
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 16'h8000; S = 4;
            @(posedge C);
            #2;
            $display("Test %0d: Right Shift 16'h8000 by 4 (C=1)", test_num);
            #1;

            check_outputs(16'h0800);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            A = 16'hABCD; S = 0;
            @(posedge C);
            @(negedge C);
            #2;
            $display("Test %0d: Left Shift 16'hABCD by 0 (C=0)", test_num);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            A = 16'hFFFF; S = 15;
            @(posedge C);
            @(negedge C);
            #2;
            $display("Test %0d: Left Shift 16'hFFFF by 15 (C=0)", test_num);
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            A = 16'hFFFF; S = 15;
            @(posedge C);
            #2;
            $display("Test %0d: Right Shift 16'hFFFF by 15 (C=1)", test_num);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            A = 16'hF00F; S = 8;
            @(posedge C);
            @(negedge C);
            #2;
            $display("Test %0d: Left Shift 16'hF00F by 8 (C=0)", test_num);
            #1;

            check_outputs(16'h0F00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            A = 16'hF00F; S = 8;
            @(posedge C);
            #2;
            $display("Test %0d: Right Shift 16'hF00F by 8 (C=1)", test_num);
            #1;

            check_outputs(16'h00F0);
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
        input [15:0] expected_B;
        begin
            if (expected_B === (expected_B ^ B ^ expected_B)) begin
                $display("PASS");
                $display("  Outputs: B=%h",
                         B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h",
                         expected_B);
                $display("  Got:      B=%h",
                         B);
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
        $dumpvars(0,A, C, S, B);
    end

endmodule
