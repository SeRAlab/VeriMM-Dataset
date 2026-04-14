`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg S;
    reg areset;
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
        .S(S),
        .areset(areset),
        .clk(clk),
        .load(load),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        load = 0;
        S = 0;
        A = 0; B = 0; C = 0; D = 0;
        #15;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        S = 0;
        #1;
        $display("Testcase 001: Checking Reset state (S=0)");
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();


        A = 4'b0000; B = 4'b0001; C = 4'b0000; D = 4'b0001;
        load = 1;
        S = 0;
        @(posedge clk);
        #2;
        load = 0;
        $display("Testcase 002: Checking Parallel Load (1010)");
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        A = 4'b1; B = 4'b1; C = 4'b1; D = 4'b0;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;

        @(posedge clk);
        #2;
        $display("Testcase 003: Checking Single Left Shift (0111 -> 1110)");
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        A = 0; B = 0; C = 0; D = 1;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;

        @(posedge clk);
        #2;

        @(posedge clk);
        #2;
        $display("Testcase 004: Checking Multiple Shifts (1000 -> 0000)");
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();


        A = 4'b1100;
        B = 4'b0011;
        S = 1;
        #2;
        $display("Testcase 005: Checking Mux S=1 (A/B Selection)");


        #1;



        check_outputs({A[1:0], B[1:0]});
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();

        A = 4'hf; B = 4'hf; C = 4'hf; D = 4'hf;
        load = 1;
        @(posedge clk);
        #2;
        load = 0;

        S = 1;
        repeat(3) @(posedge clk);
        #2;


        S = 0;
        #2;
        $display("Testcase 006: Checking Shift activity while S is toggled");
        #1;

        check_outputs(4'b1000);
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
        $dumpvars(0,A, B, C, D, S, areset, clk, load, Q);
    end

endmodule
