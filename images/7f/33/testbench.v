`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] inputMsg;
    reg inputValid;
    wire [15:0] outputMsg;
    wire outputValid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inputMsg(inputMsg),
        .inputValid(inputValid),
        .outputMsg(outputMsg),
        .outputValid(outputValid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Write (0xAAAA)", test_num);
        inputValid = 1'b0;
        inputMsg = 16'h0000;
        #5;
        inputMsg = 16'hAAAA;
        inputValid = 1'b1;
        #5;
        #1;

        check_outputs(16'hAAAA, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Data Retention Check", test_num);

        inputMsg = 16'h1234;
        inputValid = 1'b1;
        #5;

        inputValid = 1'b0;
        inputMsg = 16'h5678;
        #5;

        #1;


        check_outputs(16'h1234, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overwrite Check", test_num);
        inputValid = 1'b1;
        inputMsg = 16'hAAAA;
        #5;
        inputMsg = 16'h5555;
        #5;
        #1;

        check_outputs(16'h5555, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All-Ones Pattern", test_num);
        inputValid = 1'b1;
        inputMsg = 16'hFFFF;
        #5;
        #1;

        check_outputs(16'hFFFF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All-Zeros Pattern", test_num);
        inputValid = 1'b1;
        inputMsg = 16'h0000;
        #5;
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multi-Write and Retention", test_num);

        inputMsg = 16'hA1B2;
        inputValid = 1'b1;
        #5;
        inputValid = 1'b0;
        #5;

        inputMsg = 16'hC3D4;
        inputValid = 1'b1;
        #5;
        inputValid = 1'b0;
        inputMsg = 16'hE5F6;
        #5;
        #1;

        check_outputs(16'hC3D4, 1'b0);
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
        input [15:0] expected_outputMsg;
        input expected_outputValid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outputMsg === (expected_outputMsg ^ outputMsg ^ expected_outputMsg) &&
                expected_outputValid === (expected_outputValid ^ outputValid ^ expected_outputValid)) begin
                $display("PASS");
                $display("  Outputs: outputMsg=%h, outputValid=%b",
                         outputMsg, outputValid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outputMsg=%h, outputValid=%b",
                         expected_outputMsg, expected_outputValid);
                $display("  Got:      outputMsg=%h, outputValid=%b",
                         outputMsg, outputValid);
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
