`timescale 1ns/1ps

module adc_24_to_decimal_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] binary_input;
    wire [31:0] decimal_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_24_to_decimal dut (
        .binary_input(binary_input),
        .decimal_output(decimal_output)
    );
    task testcase001;

    begin
        test_num = 1;
        binary_input = 24'd0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        binary_input = 24'd9;
        #1;

        check_outputs(32'h00000009);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        binary_input = 24'd10;
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        binary_input = 24'd255;
        #1;

        check_outputs(32'h00000255);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        binary_input = 24'd1024;
        #1;

        check_outputs(32'h00001024);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        binary_input = 24'd65535;
        #1;

        check_outputs(32'h00065535);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        binary_input = 24'd123456;
        #1;

        check_outputs(32'h00123456);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        binary_input = 24'd999999;
        #1;

        check_outputs(32'h00999999);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        binary_input = 24'd1000000;
        #1;

        check_outputs(32'h01000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        binary_input = 24'hFFFFFF;
        #1;

        check_outputs(32'h16777215);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_24_to_decimal Testbench");
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
        input [31:0] expected_decimal_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decimal_output === (expected_decimal_output ^ decimal_output ^ expected_decimal_output)) begin
                $display("PASS");
                $display("  Outputs: decimal_output=%h",
                         decimal_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decimal_output=%h",
                         expected_decimal_output);
                $display("  Got:      decimal_output=%h",
                         decimal_output);
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
