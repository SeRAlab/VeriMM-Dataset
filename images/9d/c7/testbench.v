`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] p;
    wire [16:0] out_eq2;
    wire [16:0] out_nand2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p(p),
        .out_eq2(out_eq2),
        .out_nand2(out_nand2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            p = 18'h00000;
            #1;

            check_outputs(17'h1FFFF, 17'b1111111111111111x);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            p = 18'h3FFFF;
            #1;

            check_outputs(17'h1FFFF, 17'b0000000000000000x);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            p = 18'h2AAAA;
            #1;

            check_outputs(17'h00000, 17'b1111111111111111x);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            p = 18'h15555;
            #1;

            check_outputs(17'h00000, 17'b1111111111111111x);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            p = 18'h0000F;
            #1;

            check_outputs(17'h1FFF7, 17'b1111111111111000x);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            p = 18'h0C000;
            #1;

            check_outputs(17'h15FFF, 17'b1011111111111111x);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            p = 18'h00003;
            #1;

            check_outputs(17'h1FFFD, 17'b1111111111111110x);
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
        input [16:0] expected_out_eq2;
        input [16:0] expected_out_nand2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_eq2 === (expected_out_eq2 ^ out_eq2 ^ expected_out_eq2) &&
                expected_out_nand2 === (expected_out_nand2 ^ out_nand2 ^ expected_out_nand2)) begin
                $display("PASS");
                $display("  Outputs: out_eq2=%h, out_nand2=%h",
                         out_eq2, out_nand2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_eq2=%h, out_nand2=%h",
                         expected_out_eq2, expected_out_nand2);
                $display("  Got:      out_eq2=%h, out_nand2=%h",
                         out_eq2, out_nand2);
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
