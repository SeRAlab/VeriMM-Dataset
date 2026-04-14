`timescale 1ns/1ps

module LDO_Control_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] control_signal;
    wire enable;
    wire [2:0] output_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Control dut (
        .control_signal(control_signal),
        .enable(enable),
        .output_voltage(output_voltage)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Control Signal = 000 (Expected: 1.2V, Enable=1)", test_num);
        control_signal = 3'b000;
        #1;

        check_outputs(1'b1, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Control Signal = 001 (Expected: 1.5V, Enable=1)", test_num);
        control_signal = 3'b001;
        #1;

        check_outputs(1'b1, 3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Control Signal = 010 (Expected: 1.8V, Enable=1)", test_num);
        control_signal = 3'b010;
        #1;

        check_outputs(1'b1, 3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Control Signal = 011 (Expected: Disabled/0V, Enable=0)", test_num);
        control_signal = 3'b011;
        #1;

        check_outputs(1'b0, 3'b000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Control Signal = 100 (Expected: Disabled/0V, Enable=0)", test_num);
        control_signal = 3'b100;
        #1;

        check_outputs(1'b0, 3'b000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Control Signal = 111 (Expected: Disabled/0V, Enable=0)", test_num);
        control_signal = 3'b111;
        #1;

        check_outputs(1'b0, 3'b000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO_Control Testbench");
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
        input expected_enable;
        input [2:0] expected_output_voltage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_enable === (expected_enable ^ enable ^ expected_enable) &&
                expected_output_voltage === (expected_output_voltage ^ output_voltage ^ expected_output_voltage)) begin
                $display("PASS");
                $display("  Outputs: enable=%b, output_voltage=%h",
                         enable, output_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enable=%b, output_voltage=%h",
                         expected_enable, expected_output_voltage);
                $display("  Got:      enable=%b, output_voltage=%h",
                         enable, output_voltage);
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
