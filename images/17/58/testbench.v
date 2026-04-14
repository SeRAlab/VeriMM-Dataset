`timescale 1ns/1ps

module DAC_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] binary_input;
    reg mode_select;
    wire [7:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC dut (
        .binary_input(binary_input),
        .mode_select(mode_select),
        .analog_output(analog_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Normal Mode - Min Value (0x0000)", test_num);
        binary_input = 16'h0000;
        mode_select = 1'b0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Normal Mode - Max Value (0xFFFF)", test_num);
        binary_input = 16'hFFFF;
        mode_select = 1'b0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Normal Mode - Mid Value (0x8000)", test_num);
        binary_input = 16'h8000;
        mode_select = 1'b0;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Normal Mode - Fractional Truncation (0x12FF)", test_num);
        binary_input = 16'h12FF;
        mode_select = 1'b0;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Inverted Mode - Min Value (0x0000)", test_num);
        binary_input = 16'h0000;
        mode_select = 1'b1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Inverted Mode - Max Value (0xFFFF)", test_num);
        binary_input = 16'hFFFF;
        mode_select = 1'b1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Inverted Mode - Mid Value (0x8000)", test_num);
        binary_input = 16'h8000;
        mode_select = 1'b1;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Inverted Mode - Arbitrary Value (0xA500)", test_num);
        binary_input = 16'hA500;
        mode_select = 1'b1;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC Testbench");
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
        input [7:0] expected_analog_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_analog_output === (expected_analog_output ^ analog_output ^ expected_analog_output)) begin
                $display("PASS");
                $display("  Outputs: analog_output=%h",
                         analog_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: analog_output=%h",
                         expected_analog_output);
                $display("  Got:      analog_output=%h",
                         analog_output);
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
