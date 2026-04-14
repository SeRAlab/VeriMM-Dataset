`timescale 1ns/1ps

module adc_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] analog_input;
    wire [7:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_8bit dut (
        .analog_input(analog_input),
        .digital_output(digital_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Analog Input = 0", test_num);
        analog_input = 3'b000;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Analog Input = 1", test_num);
        analog_input = 3'b001;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Analog Input = 2", test_num);
        analog_input = 3'b010;
        #1;

        check_outputs(8'h02);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Analog Input = 3", test_num);
        analog_input = 3'b011;
        #1;

        check_outputs(8'h03);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Analog Input = 4", test_num);
        analog_input = 3'b100;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Analog Input = 5", test_num);
        analog_input = 3'b101;
        #1;

        check_outputs(8'h05);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Analog Input = 6", test_num);
        analog_input = 3'b110;
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Analog Input = 7", test_num);
        analog_input = 3'b111;
        #1;

        check_outputs(8'h07);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_8bit Testbench");
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
        input [7:0] expected_digital_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digital_output === (expected_digital_output ^ digital_output ^ expected_digital_output)) begin
                $display("PASS");
                $display("  Outputs: digital_output=%h",
                         digital_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_output=%h",
                         expected_digital_output);
                $display("  Got:      digital_output=%h",
                         digital_output);
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
