`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire [3:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'd0;
            B = 4'd0;

            repeat(3) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge clk);
            A = 4'd5;
            B = 4'd3;

            repeat(3) @(posedge clk);
            #1;
            $display("Testcase %0d: Input A=5, B=3 (Expect 8)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge clk);
            A = 4'd15;
            B = 4'd0;
            repeat(3) @(posedge clk);
            #1;
            $display("Testcase %0d: Input A=15, B=0 (Expect 15)", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge clk);
            A = 4'd0;
            B = 4'd0;
            repeat(3) @(posedge clk);
            #1;
            $display("Testcase %0d: Input A=0, B=0 (Expect 0)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge clk);
            A = 4'd10;
            B = 4'd10;
            repeat(3) @(posedge clk);
            #1;
            $display("Testcase %0d: Input A=10, B=10 (Expect 4)", test_num);
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge clk);
            A = 4'd15;
            B = 4'd1;
            repeat(3) @(posedge clk);
            #1;
            $display("Testcase %0d: Input A=15, B=1 (Expect 0)", test_num);
            #1;

            check_outputs(4'd0);
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
        input [3:0] expected_OUT;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
        $dumpvars(0,A, B, clk, OUT);
    end

endmodule
