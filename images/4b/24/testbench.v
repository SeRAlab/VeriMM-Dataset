`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] inputs;
    wire [1:0] outputs;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inputs(inputs),
        .outputs(outputs)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: No inputs active (0000)", test_num);
        inputs = 4'b0000;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 0 active (0001)", test_num);
        inputs = 4'b0001;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 1 active (0010)", test_num);
        inputs = 4'b0010;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiple active inputs (0011) - Priority to bit 1", test_num);
        inputs = 4'b0011;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 2 active (0100)", test_num);
        inputs = 4'b0100;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiple active inputs (0111) - Priority to bit 2", test_num);
        inputs = 4'b0111;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 3 active (1000)", test_num);
        inputs = 4'b1000;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiple active inputs (1100) - Priority to bit 3", test_num);
        inputs = 4'b1100;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs active (1111) - Priority to bit 3", test_num);
        inputs = 4'b1111;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Non-contiguous inputs (1010) - Priority to bit 3", test_num);
        inputs = 4'b1010;
        #1;

        check_outputs(2'b11);
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
        input [1:0] expected_outputs;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outputs === (expected_outputs ^ outputs ^ expected_outputs)) begin
                $display("PASS");
                $display("  Outputs: outputs=%h",
                         outputs);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outputs=%h",
                         expected_outputs);
                $display("  Got:      outputs=%h",
                         outputs);
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
