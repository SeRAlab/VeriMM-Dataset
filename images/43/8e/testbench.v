`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] in;
    wire [16:0] out_left;
    wire [16:0] out_right;
    wire [17:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_left(out_left),
        .out_right(out_right),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros", test_num);
            in = 18'h00000;
            #1;

            check_outputs(17'h00000, 17'h00000, 18'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones", test_num);
            in = 18'h3FFFF;
            #1;

            check_outputs(17'h1FFFF, 17'h1FFFF, 18'h00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating 1010...", test_num);
            in = 18'h2AAAA;
            #1;

            check_outputs(17'h00000, 17'h1FFFF, 18'h3FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating 0101...", test_num);
            in = 18'h15555;
            #1;

            check_outputs(17'h00000, 17'h1FFFF, 18'h3FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Bit (Index 0)", test_num);
            in = 18'h00001;
            #1;

            check_outputs(17'h00000, 17'h00001, 18'h20001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Bit (Index 17)", test_num);
            in = 18'h20000;
            #1;

            check_outputs(17'h00000, 17'h10000, 18'h30000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Block of Ones", test_num);
            in = 18'h00700;
            #1;

            check_outputs(17'h00300, 17'h00380, 18'h00480);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Complex Pattern", test_num);
            in = 18'h12345;
            #1;

            check_outputs(17'h00100, 17'h1B3E7, 18'h3B2E7);
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
        input [16:0] expected_out_left;
        input [16:0] expected_out_right;
        input [17:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_left === (expected_out_left ^ out_left ^ expected_out_left) &&
                expected_out_right === (expected_out_right ^ out_right ^ expected_out_right) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_left=%h, out_right=%h, out_xor=%h",
                         out_left, out_right, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_left=%h, out_right=%h, out_xor=%h",
                         expected_out_left, expected_out_right, expected_out_xor);
                $display("  Got:      out_left=%h, out_right=%h, out_xor=%h",
                         out_left, out_right, out_xor);
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
