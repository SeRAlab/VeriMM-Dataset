`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] inputData;
    reg writeControl;
    wire [7:0] outputData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inputData(inputData),
        .writeControl(writeControl),
        .outputData(outputData)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Write initial value 8'hA5", test_num);
        writeControl = 1;
        inputData = 8'hA5;

        #1;


        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Hold value 8'hA5 when writeControl is low", test_num);
        writeControl = 0;
        inputData = 8'h00;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Write new value 8'h5A", test_num);
        writeControl = 1;
        inputData = 8'h5A;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Hold value 8'h5A while input changes to 8'hFF", test_num);
        writeControl = 0;
        inputData = 8'hFF;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Write all zeros", test_num);
        writeControl = 1;
        inputData = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Write all ones", test_num);
        writeControl = 1;
        inputData = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Verify output changes immediately when writeControl is active", test_num);
        writeControl = 1;
        inputData = 8'h12;
        #2;
        inputData = 8'h34;
        #1;

        check_outputs(8'h34);
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
        input [7:0] expected_outputData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outputData === (expected_outputData ^ outputData ^ expected_outputData)) begin
                $display("PASS");
                $display("  Outputs: outputData=%h",
                         outputData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outputData=%h",
                         expected_outputData);
                $display("  Got:      outputData=%h",
                         outputData);
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
