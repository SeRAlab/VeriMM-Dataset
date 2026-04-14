`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Zero input", test_num);
            data_in = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Shift LSB", test_num);
            data_in = 32'h00000001;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Shift MSB (Overflow)", test_num);
            data_in = 32'h80000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: All ones", test_num);
            data_in = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Pattern 0x55555555", test_num);
            data_in = 32'h55555555;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Pattern 0xAAAAAAAA", test_num);
            data_in = 32'hAAAAAAAA;
            #1;

            check_outputs(32'h55555554);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Random value 1", test_num);
            data_in = 32'h12345678;
            #1;

            check_outputs(32'h2468ACF0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: High bit into MSB position", test_num);
            data_in = 32'h40000000;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Boundary alternating nibble", test_num);
            data_in = 32'h0F0F0F0F;
            #1;

            check_outputs(32'h1E1E1E1E);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Max positive signed integer equivalent", test_num);
            data_in = 32'h7FFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFE);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
