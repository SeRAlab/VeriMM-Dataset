`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg I__0;
    reg [1:0] I__1;
    wire O__0;
    wire [1:0] O__1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I__0(I__0),
        .I__1(I__1),
        .O__0(O__0),
        .O__1(O__1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            I__0 = 1'b0;
            I__1 = 2'b00;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones", test_num);
            I__0 = 1'b1;
            I__1 = 2'b11;
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit toggle I__0", test_num);
            I__0 = 1'b1;
            I__1 = 2'b00;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 01 on I__1", test_num);
            I__0 = 1'b0;
            I__1 = 2'b01;
            #1;

            check_outputs(1'b0, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 10 on I__1", test_num);
            I__0 = 1'b1;
            I__1 = 2'b10;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternate bit test", test_num);
            I__0 = 1'b0;
            I__1 = 2'b11;
            #1;

            check_outputs(1'b0, 2'b11);
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
        input expected_O__0;
        input [1:0] expected_O__1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O__0 === (expected_O__0 ^ O__0 ^ expected_O__0) &&
                expected_O__1 === (expected_O__1 ^ O__1 ^ expected_O__1)) begin
                $display("PASS");
                $display("  Outputs: O__0=%b, O__1=%h",
                         O__0, O__1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O__0=%b, O__1=%h",
                         expected_O__0, expected_O__1);
                $display("  Got:      O__0=%b, O__1=%h",
                         O__0, O__1);
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
