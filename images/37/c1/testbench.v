`timescale 1ns/1ps

module LDO_Regulator_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] control;
    wire in_regulation;
    wire [3:0] output_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Regulator dut (
        .control(control),
        .in_regulation(in_regulation),
        .output_voltage(output_voltage)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Setting Control to 00 (Off/Low Output)", test_num);
            control = 2'b00;

            #1;


            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Setting Control to 01 (Regulated 3.3V)", test_num);
            control = 2'b01;

            #1;


            check_outputs(1'b1, 4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Setting Control to 10 (Regulated 5.0V)", test_num);
            control = 2'b10;

            #1;


            check_outputs(1'b1, 4'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Setting Control to 11 (High/Max Output)", test_num);
            control = 2'b11;

            #1;


            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition from High back to 3.3V Regulation", test_num);
            control = 2'b01;

            #1;


            check_outputs(1'b1, 4'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shutdown from Regulation", test_num);
            control = 2'b00;

            #1;


            check_outputs(1'b0, 4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO_Regulator Testbench");
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
        input expected_in_regulation;
        input [3:0] expected_output_voltage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_in_regulation === (expected_in_regulation ^ in_regulation ^ expected_in_regulation) &&
                expected_output_voltage === (expected_output_voltage ^ output_voltage ^ expected_output_voltage)) begin
                $display("PASS");
                $display("  Outputs: in_regulation=%b, output_voltage=%h",
                         in_regulation, output_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in_regulation=%b, output_voltage=%h",
                         expected_in_regulation, expected_output_voltage);
                $display("  Got:      in_regulation=%b, output_voltage=%h",
                         in_regulation, output_voltage);
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
