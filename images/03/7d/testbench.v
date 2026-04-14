`timescale 1ns/1ps

module adc_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] analog_input;
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
        test_num = test_num + 1;
        $display("\nTestcase %0d: Minimum Input", test_num);
        analog_input = 10'b00_0000_0000;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Maximum Input", test_num);
        analog_input = 10'b11_1111_1111;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Half-scale Input (512)", test_num);
        analog_input = 10'b10_0000_0000;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Quarter-scale Input (256)", test_num);
        analog_input = 10'b01_0000_0000;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Testing LSB truncation (Input 3)", test_num);
        analog_input = 10'b00_0000_0011;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Testing LSB truncation (Input 1020)", test_num);
        analog_input = 10'b11_1111_1100;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating Bits Pattern 1", test_num);
        analog_input = 10'b01_0101_0111;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating Bits Pattern 2", test_num);
        analog_input = 10'b10_1010_1000;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Boundary Crossing (Input 511)", test_num);
        analog_input = 10'd511;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Arbitrary Pattern", test_num);
        analog_input = 10'h123;
        #1;

        check_outputs(8'h48);
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
