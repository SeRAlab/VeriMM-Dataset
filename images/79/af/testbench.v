`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] S;
    reg [31:0] T;
    wire [31:0] quote;
    wire [31:0] rem;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S(S),
        .T(T),
        .quote(quote),
        .rem(rem)
    );
    task testcase001;

        begin
            test_num = 1;
            S = 32'd100;
            T = 32'd10;
            #1;

            check_outputs(32'd10, 32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            S = 32'd100;
            T = 32'd3;
            #1;

            check_outputs(32'd33, 32'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            S = 32'd5;
            T = 32'd10;
            #1;

            check_outputs(32'd0, 32'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            S = 32'd500;
            T = 32'd1;
            #1;

            check_outputs(32'd500, 32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            S = 32'hFFFFFFFF;
            T = 32'd1;
            #1;

            check_outputs(32'hFFFFFFFF, 32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            S = 32'hFFFFFFFF;
            T = 32'hFFFFFFFF;
            #1;

            check_outputs(32'd1, 32'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            S = 32'd0;
            T = 32'd12345;
            #1;

            check_outputs(32'd0, 32'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            S = 32'd1234567;
            T = 32'd89;
            #1;

            check_outputs(32'd13871, 32'd48);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            S = 32'd1048576;
            T = 32'd1024;
            #1;

            check_outputs(32'd1024, 32'd0);
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
        input [31:0] expected_quote;
        input [31:0] expected_rem;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quote === (expected_quote ^ quote ^ expected_quote) &&
                expected_rem === (expected_rem ^ rem ^ expected_rem)) begin
                $display("PASS");
                $display("  Outputs: quote=%h, rem=%h",
                         quote, rem);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quote=%h, rem=%h",
                         expected_quote, expected_rem);
                $display("  Got:      quote=%h, rem=%h",
                         quote, rem);
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
