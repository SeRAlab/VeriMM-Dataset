`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] c;
    wire parity;
    wire [3:0] rev_bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .parity(parity),
        .rev_bits(rev_bits)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input c = 4'b0000 (All Zeros)", test_num);
            c = 4'b0000;

            #1;


            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input c = 4'b1111 (All Ones)", test_num);
            c = 4'b1111;

            #1;


            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input c = 4'b1101 (Odd Parity)", test_num);
            c = 4'b1101;

            #1;


            check_outputs(1'b1, 4'b1011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input c = 4'b1010", test_num);
            c = 4'b1010;

            #1;


            check_outputs(1'b0, 4'b0101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input c = 4'b1000", test_num);
            c = 4'b1000;

            #1;


            check_outputs(1'b1, 4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input c = 4'b0001", test_num);
            c = 4'b0001;

            #1;


            check_outputs(1'b1, 4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input c = 4'b0110", test_num);
            c = 4'b0110;

            #1;


            check_outputs(1'b0, 4'b0110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input c = 4'b0111", test_num);
            c = 4'b0111;

            #1;


            check_outputs(1'b1, 4'b1110);
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
        input expected_parity;
        input [3:0] expected_rev_bits;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_parity === (expected_parity ^ parity ^ expected_parity) &&
                expected_rev_bits === (expected_rev_bits ^ rev_bits ^ expected_rev_bits)) begin
                $display("PASS");
                $display("  Outputs: parity=%b, rev_bits=%h",
                         parity, rev_bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity=%b, rev_bits=%h",
                         expected_parity, expected_rev_bits);
                $display("  Got:      parity=%b, rev_bits=%h",
                         parity, rev_bits);
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
