`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] B;
    reg clk;
    wire [3:0] E;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .clk(clk),
        .E(E)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            B = 4'b0000;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            B = 4'd0;

            repeat (3) @(posedge clk);
            $display("Test %0d: Input B=0", test_num);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            B = 4'd5;
            repeat (3) @(posedge clk);
            $display("Test %0d: Input B=5", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            B = 4'd9;
            repeat (3) @(posedge clk);
            $display("Test %0d: Input B=9", test_num);
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            B = 4'd12;
            repeat (3) @(posedge clk);
            $display("Test %0d: Input B=12", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            B = 4'd13;
            repeat (3) @(posedge clk);
            $display("Test %0d: Input B=13 (Overflow)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            B = 4'd15;
            repeat (3) @(posedge clk);
            $display("Test %0d: Input B=15 (Overflow)", test_num);
            #1;

            check_outputs(4'd2);
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
        input [3:0] expected_E;
        begin
            if (expected_E === (expected_E ^ E ^ expected_E)) begin
                $display("PASS");
                $display("  Outputs: E=%h",
                         E);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: E=%h",
                         expected_E);
                $display("  Got:      E=%h",
                         E);
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
        $dumpvars(0,B, clk, E);
    end

endmodule
