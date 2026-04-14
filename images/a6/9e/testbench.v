`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] G;
    wire [3:0] bin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .G(G),
        .bin(bin)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gray 0000 -> Binary 0000", test_num);
            G = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gray 0001 -> Binary 0001", test_num);
            G = 4'b0001;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gray 0011 -> Binary 0010", test_num);
            G = 4'b0011;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gray 0010 -> Binary 0011", test_num);
            G = 4'b0010;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gray 0110 -> Binary 0100", test_num);
            G = 4'b0110;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gray 0111 -> Binary 0101", test_num);
            G = 4'b0111;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gray 0101 -> Binary 0110", test_num);
            G = 4'b0101;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gray 0100 -> Binary 0111", test_num);
            G = 4'b0100;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gray 1100 -> Binary 1000", test_num);
            G = 4'b1100;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gray 1000 -> Binary 1111", test_num);
            G = 4'b1000;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Gray 1111 -> Binary 1010", test_num);
            G = 4'b1111;
            #1;

            check_outputs(4'b1010);
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
        testcase011();
        
        
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
        input [3:0] expected_bin;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bin === (expected_bin ^ bin ^ expected_bin)) begin
                $display("PASS");
                $display("  Outputs: bin=%h",
                         bin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bin=%h",
                         expected_bin);
                $display("  Got:      bin=%h",
                         bin);
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
