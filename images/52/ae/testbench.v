`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] DIN;
    reg [3:0] S;
    reg clk;
    reg reset;
    wire [7:0] DAC_out;
    wire [15:0] Y;
    wire [15:0] final_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .DIN(DIN),
        .S(S),
        .clk(clk),
        .reset(reset),
        .DAC_out(DAC_out),
        .Y(Y),
        .final_output(final_output)
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
            DIN = 0;
            S = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset and Zero check");
            reset_dut();
            #1;

            check_outputs(8'h00, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: DAC calculation (DIN=2)");
            reset_dut();
            DIN = 4'd2;
            A = 16'h0000;
            S = 4'd0;
            #1;

            check_outputs(8'h80, 16'h0000, 16'h0080);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Shifter check (A=1, S=4)");
            reset_dut();
            DIN = 4'd0;
            A = 16'h0001;
            S = 4'd4;
            #1;

            check_outputs(8'h00, 16'h0010, 16'h0010);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Combined Logic");
            reset_dut();
            DIN = 4'd1;
            A = 16'h00FF;
            S = 4'd8;
            #1;

            check_outputs(8'h40, 16'hFF00, 16'hFF40);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary/Overflow check");
            reset_dut();
            DIN = 4'd4;
            A = 16'h8000;
            S = 4'd1;


            #1;



            check_outputs(8'h00, 16'h0000, 16'h0000);
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
        input [7:0] expected_DAC_out;
        input [15:0] expected_Y;
        input [15:0] expected_final_output;
        begin
            if (expected_DAC_out === (expected_DAC_out ^ DAC_out ^ expected_DAC_out) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output)) begin
                $display("PASS");
                $display("  Outputs: DAC_out=%h, Y=%h, final_output=%h",
                         DAC_out, Y, final_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DAC_out=%h, Y=%h, final_output=%h",
                         expected_DAC_out, expected_Y, expected_final_output);
                $display("  Got:      DAC_out=%h, Y=%h, final_output=%h",
                         DAC_out, Y, final_output);
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
        $dumpvars(0,A, B, DIN, S, clk, reset, DAC_out, Y, final_output);
    end

endmodule
