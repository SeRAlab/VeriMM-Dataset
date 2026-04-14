`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] addressIn;
    reg choose;
    reg [15:0] memoryIn;
    wire [15:0] resultOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addressIn(addressIn),
        .choose(choose),
        .memoryIn(memoryIn),
        .resultOut(resultOut)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select memoryIn (choose=0)", test_num);
            memoryIn = 16'hABCD;
            addressIn = 16'h1234;
            choose = 1'b0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select addressIn (choose=1)", test_num);
            memoryIn = 16'hABCD;
            addressIn = 16'h1234;
            choose = 1'b1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros, select memoryIn", test_num);
            memoryIn = 16'h0000;
            addressIn = 16'hFFFF;
            choose = 1'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones, select addressIn", test_num);
            memoryIn = 16'h0000;
            addressIn = 16'hFFFF;
            choose = 1'b1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating pattern, select memoryIn", test_num);
            memoryIn = 16'h5555;
            addressIn = 16'hAAAA;
            choose = 1'b0;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating pattern, select addressIn", test_num);
            memoryIn = 16'h5555;
            addressIn = 16'hAAAA;
            choose = 1'b1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Changing data with choose=0", test_num);
            memoryIn = 16'hFEED;
            addressIn = 16'hBEEF;
            choose = 1'b0;
            #1;

            check_outputs(16'hFEED);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Changing data with choose=1", test_num);
            memoryIn = 16'hFEED;
            addressIn = 16'hBEEF;
            choose = 1'b1;
            #1;

            check_outputs(16'hBEEF);
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
        input [15:0] expected_resultOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_resultOut === (expected_resultOut ^ resultOut ^ expected_resultOut)) begin
                $display("PASS");
                $display("  Outputs: resultOut=%h",
                         resultOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: resultOut=%h",
                         expected_resultOut);
                $display("  Got:      resultOut=%h",
                         resultOut);
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
