`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [29:0] in0;
    reg [29:0] in1;
    reg select;
    wire [29:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .select(select),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Select in0 with standard values");
            test_num = 1;
            in0 = 30'h12345678;
            in1 = 30'h29abcdef;
            select = 0;
            #1;

            check_outputs(30'h12345678);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select in1 with standard values");
            test_num = 2;
            in0 = 30'h12345678;
            in1 = 30'h29abcdef;
            select = 1;
            #1;

            check_outputs(30'h29abcdef);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Select in0 with all 1s");
            test_num = 3;
            in0 = 30'h3FFFFFFF;
            in1 = 30'h00000000;
            select = 0;
            #1;

            check_outputs(30'h3FFFFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Select in1 with all 1s");
            test_num = 4;
            in0 = 30'h00000000;
            in1 = 30'h3FFFFFFF;
            select = 1;
            #1;

            check_outputs(30'h3FFFFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Select in0 with alternating bits");
            test_num = 5;
            in0 = 30'h15555555;
            in1 = 30'h2AAAAAAA;
            select = 0;
            #1;

            check_outputs(30'h15555555);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Select in1 with alternating bits");
            test_num = 6;
            in0 = 30'h15555555;
            in1 = 30'h2AAAAAAA;
            select = 1;
            #1;

            check_outputs(30'h2AAAAAAA);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Select in0 with minimum value");
            test_num = 7;
            in0 = 30'h00000000;
            in1 = 30'h3FFFFFFF;
            select = 0;
            #1;

            check_outputs(30'h00000000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Select in1 with minimum value");
            test_num = 8;
            in0 = 30'h3FFFFFFF;
            in1 = 30'h00000000;
            select = 1;
            #1;

            check_outputs(30'h00000000);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Select signal as unknown (X)");
            test_num = 9;
            in0 = 30'h11111111;
            in1 = 30'h22222222;
            select = 1'bx;

            #1;


            check_outputs(30'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
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
        input [29:0] expected_out;
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
