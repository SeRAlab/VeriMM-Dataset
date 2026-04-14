`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            a = 32'h0000_0000;
            b = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones (Self-Inverse)", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity - XOR with Zero", test_num);
            a = 32'h1234_5678;
            b = 32'h0000_0000;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise Inversion - XOR with All Ones", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Checkerboard Pattern", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Nibble Swap Pattern", test_num);
            a = 32'h0F0F_0F0F;
            b = 32'hF0F0_F0F0;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arbitrary Mixed Values", test_num);
            a = 32'hCAFE_BABE;
            b = 32'hDEAD_BEEF;
            #1;

            check_outputs(32'hCAFE_BABE ^ 32'hDEAD_BEEF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Walking Bit Test", test_num);
            a = 32'h0000_0001;
            b = 32'h8000_0000;
            #1;

            check_outputs(32'h8000_0001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Opposite MSB/LSB", test_num);
            a = 32'hFFFF_0000;
            b = 32'h0000_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Prime-like bit distribution", test_num);
            a = 32'h5A5A_A5A5;
            b = 32'h3C3C_C3C3;
            #1;

            check_outputs(32'h5A5A_A5A5 ^ 32'h3C3C_C3C3);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
