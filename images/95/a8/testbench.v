`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire [3:0] C;
    wire D;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .C(C),
        .D(D)
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
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A = 4'b1111;
            B = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 4'b1111;
            B = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 4'b1010;
            B = 4'b1100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 4'b0111;
            B = 4'b0111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0111, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A = 4'b1010;
            B = 4'b0101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A = 4'b1001;
            B = 4'b1011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1001, 1'b1);
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
        input [3:0] expected_C;
        input expected_D;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_D === (expected_D ^ D ^ expected_D)) begin
                $display("PASS");
                $display("  Outputs: C=%h, D=%b",
                         C, D);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, D=%b",
                         expected_C, expected_D);
                $display("  Got:      C=%h, D=%b",
                         C, D);
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
        $dumpvars(0,A, B, clk, C, D);
    end

endmodule
