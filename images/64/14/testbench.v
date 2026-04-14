`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
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
        .clk(clk),
        .load(load),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 4'h0; B = 4'h0; C = 4'h0; D = 4'h0;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            A = 4'hA; B = 4'hB; C = 4'hC; D = 4'hD;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            $display("Testcase 001: Basic Parallel Load (Expected Q=A)");
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 4'hA; B = 4'hB; C = 4'hC; D = 4'hD;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(4) @(posedge clk);
            #1;
            $display("Testcase 002: Shift 4 bits (Expected Q=B)");
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            A = 4'hA; B = 4'hB; C = 4'hC; D = 4'hD;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(8) @(posedge clk);
            #1;
            $display("Testcase 003: Shift 8 bits (Expected Q=C)");
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            A = 4'hA; B = 4'hB; C = 4'hC; D = 4'hD;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(12) @(posedge clk);
            #1;
            $display("Testcase 004: Shift 12 bits (Expected Q=D)");
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            A = 4'h5; B = 4'h5; C = 4'h5; D = 4'h5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            $display("Testcase 005: Bit-level shift (0101 -> 1010) (Expected Q=A)");
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            A = 4'h2; B = 4'h2; C = 4'h2; D = 4'h2;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(2) @(posedge clk);
            #1;
            $display("Testcase 006: Shift 2 bits (0010 -> 1000) (Expected Q=8)");
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            A = 4'hF; B = 4'hF; C = 4'hF; D = 4'hF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(16) @(posedge clk);
            #1;
            $display("Testcase 007: Shift until zero-filled (Expected Q=0)");
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            A = 4'h1; B = 4'h2; C = 4'h3; D = 4'h4;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            repeat(2) @(posedge clk);
            #1;
            A = 4'hE; B = 4'h0; C = 4'h0; D = 4'h0;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            $display("Testcase 008: Load priority override (Expected Q=E)");
            #1;

            check_outputs(4'hE);
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
        $dumpvars(0,A, B, C, D, clk, load, Q);
    end

endmodule
