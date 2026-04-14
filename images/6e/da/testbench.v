`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] A;
    reg [1:0] B;
    reg clk;
    wire F;
    wire [3:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .F(F),
        .P(P)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 2'b00;
            B = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task run_test;

        input [1:0] in_a;
        input [1:0] in_b;
        input [3:0] exp_p;
        input exp_f;
        begin
            test_num = test_num + 1;
            A = in_a;
            B = in_b;


            repeat(5) @(posedge clk);
            #1;
            $display("Test %0d: A=%d, B=%d", test_num, $signed(in_a), $signed(in_b));
            #1;

            check_outputs(exp_f, exp_p);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            run_test(2'b00, 2'b00, 4'b0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            run_test(2'b01, 2'b01, 4'b0001, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            run_test(2'b01, 2'b11, 4'b1111, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            run_test(2'b11, 2'b01, 4'b1111, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            run_test(2'b11, 2'b11, 4'b0001, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            run_test(2'b01, 2'b10, 4'b1110, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            run_test(2'b10, 2'b01, 4'b1110, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            run_test(2'b10, 2'b11, 4'b0010, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            run_test(2'b10, 2'b10, 4'b0100, 1'b0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            run_test(2'b00, 2'b10, 4'b0000, 1'b0);
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
        testcase009();
        testcase010();
        
        
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
        input expected_F;
        input [3:0] expected_P;
        begin
            if (expected_F === (expected_F ^ F ^ expected_F) &&
                expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: F=%b, P=%h",
                         F, P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%b, P=%h",
                         expected_F, expected_P);
                $display("  Got:      F=%b, P=%h",
                         F, P);
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
        $dumpvars(0,A, B, clk, F, P);
    end

endmodule
