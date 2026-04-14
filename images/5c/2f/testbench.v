`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input1;
    reg [31:0] input2;
    reg src;
    wire [31:0] outputResult;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input1(input1),
        .input2(input2),
        .src(src),
        .outputResult(outputResult)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: src=0, select input1 (all zeros vs all ones)", test_num);
            src = 1'b0;
            input1 = 32'h00000000;
            input2 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: src=1, select input2 (all zeros vs all ones)", test_num);
            src = 1'b1;
            input1 = 32'h00000000;
            input2 = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: src=0, select input1 (alternating bits)", test_num);
            src = 1'b0;
            input1 = 32'hAAAAAAAA;
            input2 = 32'h55555555;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: src=1, select input2 (alternating bits)", test_num);
            src = 1'b1;
            input1 = 32'hAAAAAAAA;
            input2 = 32'h55555555;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: src=0, select input1 (random pattern)", test_num);
            src = 1'b0;
            input1 = 32'h12345678;
            input2 = 32'h87654321;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: src=1, select input2 (random pattern)", test_num);
            src = 1'b1;
            input1 = 32'h12345678;
            input2 = 32'h87654321;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: src=0, select input1 (hex code)", test_num);
            src = 1'b0;
            input1 = 32'hDEADBEEF;
            input2 = 32'hCAFEBABE;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: src=1, select input2 (hex code)", test_num);
            src = 1'b1;
            input1 = 32'hDEADBEEF;
            input2 = 32'hCAFEBABE;
            #1;

            check_outputs(32'hCAFEBABE);
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
        input [31:0] expected_outputResult;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outputResult === (expected_outputResult ^ outputResult ^ expected_outputResult)) begin
                $display("PASS");
                $display("  Outputs: outputResult=%h",
                         outputResult);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outputResult=%h",
                         expected_outputResult);
                $display("  Got:      outputResult=%h",
                         outputResult);
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
