`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [32:0] R0;
    reg [32:0] R1;
    reg SEL_BUS;
    wire [32:0] TO_BUS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .R0(R0),
        .R1(R1),
        .SEL_BUS(SEL_BUS),
        .TO_BUS(TO_BUS)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select R0 (All Zeros)", test_num);
            R0 = 33'h0_0000_0000;
            R1 = 33'h1_FFFF_FFFF;
            SEL_BUS = 1'b0;
            #1;

            check_outputs(33'h0_0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select R1 (All Ones)", test_num);
            R0 = 33'h0_0000_0000;
            R1 = 33'h1_FFFF_FFFF;
            SEL_BUS = 1'b1;
            #1;

            check_outputs(33'h1_FFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select R0 (Pattern A)", test_num);
            R0 = 33'h1_5555_AAAA;
            R1 = 33'h0_AAAA_5555;
            SEL_BUS = 1'b0;
            #1;

            check_outputs(33'h1_5555_AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select R1 (Pattern B)", test_num);
            R0 = 33'h1_5555_AAAA;
            R1 = 33'h0_AAAA_5555;
            SEL_BUS = 1'b1;
            #1;

            check_outputs(33'h0_AAAA_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB check on R0", test_num);
            R0 = 33'h1_0000_0000;
            R1 = 33'h0_0000_0000;
            SEL_BUS = 1'b0;
            #1;

            check_outputs(33'h1_0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB check on R1", test_num);
            R0 = 33'h0_0000_0000;
            R1 = 33'h1_0000_0000;
            SEL_BUS = 1'b1;
            #1;

            check_outputs(33'h1_0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Selection R0 random walk", test_num);
            R0 = 33'h0_1234_5678;
            R1 = 33'h0_FEDC_BA98;
            SEL_BUS = 1'b0;
            #1;

            check_outputs(33'h0_1234_5678);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select R1 (Alternating bits)", test_num);
            R0 = 33'h1_AAAA_AAAA;
            R1 = 33'h0_5555_5555;
            SEL_BUS = 1'b1;
            #1;

            check_outputs(33'h0_5555_5555);
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
        input [32:0] expected_TO_BUS;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_TO_BUS === (expected_TO_BUS ^ TO_BUS ^ expected_TO_BUS)) begin
                $display("PASS");
                $display("  Outputs: TO_BUS=%h",
                         TO_BUS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TO_BUS=%h",
                         expected_TO_BUS);
                $display("  Got:      TO_BUS=%h",
                         TO_BUS);
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
