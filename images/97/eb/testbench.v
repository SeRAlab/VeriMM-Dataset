`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg clk;
    wire [31:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .P(P)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            repeat (LATENCY) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A = 16'h0000;
            B = 16'h0000;
            A_stored = A; B_stored = B;
            repeat (LATENCY) @(posedge clk);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 16'hFFFF;
            B = 16'hFFFF;
            A_stored = A; B_stored = B;
            repeat (LATENCY) @(posedge clk);

            #1;


            check_outputs(32'hFFFE0001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 16'h1234;
            B = 16'h0001;
            A_stored = A; B_stored = B;
            repeat (LATENCY) @(posedge clk);
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 16'h00FF;
            B = 16'h00FF;
            A_stored = A; B_stored = B;
            repeat (LATENCY) @(posedge clk);

            #1;


            check_outputs(32'h0000FE01);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A = 16'h0100;
            B = 16'h0100;
            A_stored = A; B_stored = B;
            repeat (LATENCY) @(posedge clk);

            #1;


            check_outputs(32'h00010000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A = 16'h5555;
            B = 16'hAAAA;
            A_stored = A; B_stored = B;
            repeat (LATENCY) @(posedge clk);

            #1;


            check_outputs(32'h38E31C3A);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            A = 16'h8000;
            B = 16'h0002;
            A_stored = A; B_stored = B;
            repeat (LATENCY) @(posedge clk);
            #1;

            check_outputs(32'h00010000);
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
        input [31:0] expected_P;
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
        $dumpvars(0,A, B, clk, P);
    end

endmodule
