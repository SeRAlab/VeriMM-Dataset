`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg reset;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .reset(reset),
        .P(P)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0;
            B = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 4'd3;
            B = 4'd2;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(8'd6);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 4'd3;
            B = 4'b1110;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(8'hFA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 4'b1101;
            B = 4'd4;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(8'hF4);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 4'b1100;
            B = 4'b1101;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(8'd12);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = 4'd7;
            B = 4'd0;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 4'd7;
            B = 4'd7;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(8'd49);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = 4'b1000;
            B = 4'd7;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(8'hC8);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            A = 4'b1000;
            B = 4'b1000;
            repeat(8) @(posedge clk);
            #1;

            check_outputs(8'h40);
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
        testcase008();
        
        
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
        input [7:0] expected_P;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
        $dumpvars(0,A, B, clk, reset, P);
    end

endmodule
