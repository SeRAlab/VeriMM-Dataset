`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] dividend;
    reg [63:0] divisor;
    wire [63:0] quotient;
    wire [63:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder)
    );
    task testcase001;

        begin

            dividend = 64'd0;
            divisor = 64'd500;
            #1;

            check_outputs(64'd0, 64'd0);
        end
        endtask

    task testcase002;

        begin

            dividend = 64'hAABBCCDD_11223344;
            divisor = 64'd0;
            #1;

            check_outputs(64'd0, 64'd0);
        end
        endtask

    task testcase003;

        begin

            dividend = 64'd100;
            divisor = 64'd10;
            #1;

            check_outputs(64'd10, 64'd0);
        end
        endtask

    task testcase004;

        begin

            dividend = 64'd100;
            divisor = 64'd3;
            #1;

            check_outputs(64'd33, 64'd1);
        end
        endtask

    task testcase005;

        begin

            dividend = 64'd50;
            divisor = 64'd100;
            #1;

            check_outputs(64'd0, 64'd50);
        end
        endtask

    task testcase006;

        begin

            dividend = 64'hFFFFFFFF_FFFFFFFF;
            divisor = 64'd1;
            #1;

            check_outputs(64'hFFFFFFFF_FFFFFFFF, 64'd0);
        end
        endtask

    task testcase007;

        begin

            dividend = 64'hFFFFFFFF_FFFFFFFF;
            divisor = 64'hFFFFFFFF_FFFFFFFF;
            #1;

            check_outputs(64'd1, 64'd0);
        end
        endtask

    task testcase008;

        begin

            dividend = 64'hFEDCBA98_76543210;
            divisor = 64'h100000000;
            #1;

            check_outputs(64'h00000000_FEDCBA98, 64'h00000000_76543210);
        end
        endtask

    task testcase009;

        begin

            dividend = 64'd123456789;
            divisor = 64'd7;
            #1;

            check_outputs(64'd17636684, 64'd1);
        end
        endtask

    task testcase010;

        begin

            dividend = 64'h80000000_00000000;
            divisor = 64'h2;
            #1;

            check_outputs(64'h40000000_00000000, 64'd0);
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
        input [63:0] expected_quotient;
        input [63:0] expected_remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: quotient=%h, remainder=%h",
                         quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quotient=%h, remainder=%h",
                         expected_quotient, expected_remainder);
                $display("  Got:      quotient=%h, remainder=%h",
                         quotient, remainder);
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
