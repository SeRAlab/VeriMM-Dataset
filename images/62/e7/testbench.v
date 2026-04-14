`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg FPGA_DIR;
    reg FPGA_OUT;
    reg SOC_IN;
    wire FPGA_IN;
    wire SOC_DIR;
    wire SOC_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .FPGA_DIR(FPGA_DIR),
        .FPGA_OUT(FPGA_OUT),
        .SOC_IN(SOC_IN),
        .FPGA_IN(FPGA_IN),
        .SOC_DIR(SOC_DIR),
        .SOC_OUT(SOC_OUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All signals low", test_num);
            SOC_IN = 1'b0;
            FPGA_OUT = 1'b0;
            FPGA_DIR = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SOC_IN high, others low", test_num);
            SOC_IN = 1'b1;
            FPGA_OUT = 1'b0;
            FPGA_DIR = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: FPGA_OUT high, others low", test_num);
            SOC_IN = 1'b0;
            FPGA_OUT = 1'b1;
            FPGA_DIR = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: FPGA_DIR high, others low", test_num);
            SOC_IN = 1'b0;
            FPGA_OUT = 1'b0;
            FPGA_DIR = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SOC_IN and FPGA_OUT high", test_num);
            SOC_IN = 1'b1;
            FPGA_OUT = 1'b1;
            FPGA_DIR = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SOC_IN and FPGA_DIR high", test_num);
            SOC_IN = 1'b1;
            FPGA_OUT = 1'b0;
            FPGA_DIR = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: FPGA_OUT and FPGA_DIR high", test_num);
            SOC_IN = 1'b0;
            FPGA_OUT = 1'b1;
            FPGA_DIR = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All signals high", test_num);
            SOC_IN = 1'b1;
            FPGA_OUT = 1'b1;
            FPGA_DIR = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
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
        input expected_FPGA_IN;
        input expected_SOC_DIR;
        input expected_SOC_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_FPGA_IN === (expected_FPGA_IN ^ FPGA_IN ^ expected_FPGA_IN) &&
                expected_SOC_DIR === (expected_SOC_DIR ^ SOC_DIR ^ expected_SOC_DIR) &&
                expected_SOC_OUT === (expected_SOC_OUT ^ SOC_OUT ^ expected_SOC_OUT)) begin
                $display("PASS");
                $display("  Outputs: FPGA_IN=%b, SOC_DIR=%b, SOC_OUT=%b",
                         FPGA_IN, SOC_DIR, SOC_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FPGA_IN=%b, SOC_DIR=%b, SOC_OUT=%b",
                         expected_FPGA_IN, expected_SOC_DIR, expected_SOC_OUT);
                $display("  Got:      FPGA_IN=%b, SOC_DIR=%b, SOC_OUT=%b",
                         FPGA_IN, SOC_DIR, SOC_OUT);
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
