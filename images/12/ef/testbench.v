`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] input_voltage;
    wire [2:0] output_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .input_voltage(input_voltage),
        .output_voltage(output_voltage)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Input = 0", test_num);
        input_voltage = 5'd0;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Input = 2", test_num);
        input_voltage = 5'd2;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Input = 3", test_num);
        input_voltage = 5'd3;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Input = 6", test_num);
        input_voltage = 5'd6;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Input = 9", test_num);
        input_voltage = 5'd9;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Input = 10 (Truncation check)", test_num);
        input_voltage = 5'd10;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Input = 31 (Max input)", test_num);
        input_voltage = 5'd31;
        #1;

        check_outputs(3'd5);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_regulator Testbench");
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
        input [2:0] expected_output_voltage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_voltage === (expected_output_voltage ^ output_voltage ^ expected_output_voltage)) begin
                $display("PASS");
                $display("  Outputs: output_voltage=%h",
                         output_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_voltage=%h",
                         expected_output_voltage);
                $display("  Got:      output_voltage=%h",
                         output_voltage);
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
