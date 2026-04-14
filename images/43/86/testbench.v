`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [14:0] in;
    wire [13:0] out_nand;
    wire [13:0] out_or;
    wire [14:0] out_xor_wrap;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_nand(out_nand),
        .out_or(out_or),
        .out_xor_wrap(out_xor_wrap)
    );
    task run_test;

        input [14:0] test_in;
        reg [14:0] exp_xor;
        reg [13:0] exp_nand;
        reg [13:0] exp_or;
        integer i;
        begin
            in = test_in;

            for (i = 0; i < 15; i = i + 1) begin
                exp_xor[i] = test_in[i] ^ test_in[(i+1)%15];
            end

            for (i = 0; i < 14; i = i + 1) begin
                exp_nand[i] = ~(test_in[i+1] & test_in[i]);
            end

            for (i = 0; i < 14; i = i + 1) begin
                exp_or[i] = test_in[i] | test_in[i+1];
            end

            #1;


            check_outputs(exp_nand, exp_or, exp_xor);
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: All Zeros");
            run_test(15'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All Ones");
            run_test(15'h7FFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Alternating Bits 1010...");
            run_test(15'h5555);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Alternating Bits 0101...");
            run_test(15'h2AAA);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Single Bit Set (Bit 0)");
            run_test(15'h0001);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Single Bit Set (Bit 14)");
            run_test(15'h4000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Walking Bit Pattern");
            run_test(15'h1234);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Boundary bits interaction");
            run_test(15'h4001);
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
        input [13:0] expected_out_nand;
        input [13:0] expected_out_or;
        input [14:0] expected_out_xor_wrap;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_nand === (expected_out_nand ^ out_nand ^ expected_out_nand) &&
                expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor_wrap === (expected_out_xor_wrap ^ out_xor_wrap ^ expected_out_xor_wrap)) begin
                $display("PASS");
                $display("  Outputs: out_nand=%h, out_or=%h, out_xor_wrap=%h",
                         out_nand, out_or, out_xor_wrap);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_nand=%h, out_or=%h, out_xor_wrap=%h",
                         expected_out_nand, expected_out_or, expected_out_xor_wrap);
                $display("  Got:      out_nand=%h, out_or=%h, out_xor_wrap=%h",
                         out_nand, out_or, out_xor_wrap);
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

endmodule
