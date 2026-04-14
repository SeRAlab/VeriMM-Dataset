`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg clk;
    reg sof;
    wire [35:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .sof(sof),
        .C(C)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 16'd0;
            B = 16'd0;
            sof = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            sof = 1; A = 16'd10; B = 16'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(36'h320);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            sof = 1; A = 16'd10; B = 16'd2;
            @(posedge clk);
            #1;
            sof = 0; A = 16'd5; B = 16'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(36'h280);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            sof = 1; A = 16'd100; B = 16'd1;
            @(posedge clk);
            #1;
            sof = 0; A = 16'd50; B = 16'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(36'h640);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            sof = 1; A = 16'd5; B = 16'd5;
            @(posedge clk);
            #1;
            sof = 1; A = 16'd12; B = 16'd2;
            @(posedge clk);
            #1;
            sof = 0; A = 16'd1; B = 16'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(36'h190);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            sof = 1; A = 16'hFFFF; B = 16'h1;
            @(posedge clk);
            #1;
            sof = 0; A = 16'h8000; B = 16'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(36'h1FFF10);
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
        input [35:0] expected_C;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
        $dumpvars(0,A, B, clk, sof, C);
    end

endmodule
