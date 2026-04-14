`timescale 1ns/1ps

module adc_converter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] analog_input;
    wire [2:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_converter dut (
        .analog_input(analog_input),
        .digital_output(digital_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Input 0 (Lower boundary of 0-63)");
        analog_input = 8'd0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Input 32 (Midpoint of 0-63)");
        analog_input = 8'd32;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Input 63 (Upper boundary of 0-63)");
        analog_input = 8'd63;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Input 64 (Lower boundary of 64-127)");
        analog_input = 8'd64;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Input 96 (Midpoint of 64-127)");
        analog_input = 8'd96;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Input 127 (Upper boundary of 64-127)");
        analog_input = 8'd127;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Input 128 (Lower boundary of 128-191)");
        analog_input = 8'd128;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Input 160 (Midpoint of 128-191)");
        analog_input = 8'd160;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Input 191 (Upper boundary of 128-191)");
        analog_input = 8'd191;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Input 192 (Lower boundary of 192-255)");
        analog_input = 8'd192;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case 011: Input 224 (Midpoint of 192-255)");
        analog_input = 8'd224;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test Case 012: Input 255 (Upper boundary of 192-255)");
        analog_input = 8'd255;
        #1;

        check_outputs(3'b011);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_converter Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input [2:0] expected_digital_output;
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
