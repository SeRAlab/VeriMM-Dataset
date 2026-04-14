`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] functField;
    wire [8:0] controlData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .functField(functField),
        .controlData(controlData)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: functField = 6'h00", test_num);
        functField = 6'h00;
        #1;

        check_outputs(9'b000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: functField = 6'h20", test_num);
        functField = 6'h20;
        #1;

        check_outputs(9'b100110000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: functField = 6'h22", test_num);
        functField = 6'h22;
        #1;

        check_outputs(9'b100110010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: functField = 6'h24", test_num);
        functField = 6'h24;
        #1;

        check_outputs(9'b100110100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: functField = 6'h25", test_num);
        functField = 6'h25;
        #1;

        check_outputs(9'b100110101);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: functField = 6'h2A", test_num);
        functField = 6'h2A;
        #1;

        check_outputs(9'b100111010);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: functField = 6'h15", test_num);
        functField = 6'h15;
        #1;

        check_outputs(9'b011011011);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: functField = 6'h3F", test_num);
        functField = 6'h3F;
        #1;

        check_outputs(9'b111111111);
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
        input [8:0] expected_controlData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_controlData === (expected_controlData ^ controlData ^ expected_controlData)) begin
                $display("PASS");
                $display("  Outputs: controlData=%h",
                         controlData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: controlData=%h",
                         expected_controlData);
                $display("  Got:      controlData=%h",
                         controlData);
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
