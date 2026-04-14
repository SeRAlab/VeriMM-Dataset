`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ADDER_FOUR_IN;
    wire [31:0] ADDER_FOUR_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDER_FOUR_IN(ADDER_FOUR_IN),
        .ADDER_FOUR_OUT(ADDER_FOUR_OUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input 0", test_num);
            ADDER_FOUR_IN = 32'd0;
            #1;

            check_outputs(32'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input 100", test_num);
            ADDER_FOUR_IN = 32'd100;
            #1;

            check_outputs(32'd104);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input FFFFFFFB", test_num);
            ADDER_FOUR_IN = 32'hFFFFFFFB;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input FFFFFFFC", test_num);
            ADDER_FOUR_IN = 32'hFFFFFFFC;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input FFFFFFFF", test_num);
            ADDER_FOUR_IN = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000003);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input 12345678", test_num);
            ADDER_FOUR_IN = 32'h12345678;
            #1;

            check_outputs(32'h1234567C);
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
        input [31:0] expected_ADDER_FOUR_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ADDER_FOUR_OUT === (expected_ADDER_FOUR_OUT ^ ADDER_FOUR_OUT ^ expected_ADDER_FOUR_OUT)) begin
                $display("PASS");
                $display("  Outputs: ADDER_FOUR_OUT=%h",
                         ADDER_FOUR_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ADDER_FOUR_OUT=%h",
                         expected_ADDER_FOUR_OUT);
                $display("  Got:      ADDER_FOUR_OUT=%h",
                         ADDER_FOUR_OUT);
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
