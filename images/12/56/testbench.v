`timescale 1ns/1ps

module DAC_24bit_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] binary_input;
    wire [31:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_24bit dut (
        .binary_input(binary_input),
        .analog_output(analog_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Input 0 (0V)", test_num);
        binary_input = 24'h000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input 16777215 (5V)", test_num);
        binary_input = 24'hFFFFFF;
        #1;

        check_outputs(32'h00000500);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Input 8388608 (2.5V)", test_num);
        binary_input = 24'h800000;
        #1;

        check_outputs(32'h00000280);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Input 4194304 (1.25V)", test_num);
        binary_input = 24'h400000;
        #1;

        check_outputs(32'h00000140);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Input 3355443 (1.0V)", test_num);
        binary_input = 24'd3355443;
        #1;

        check_outputs(32'h00000100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Input 13421772 (4.0V)", test_num);
        binary_input = 24'd13421772;
        #1;

        check_outputs(32'h00000400);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Input 12582912 (3.75V)", test_num);
        binary_input = 24'd12582912;
        #1;

        check_outputs(32'h000003C0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Input 15099494 (4.5V)", test_num);
        binary_input = 24'd15099494;
        #1;

        check_outputs(32'h00000480);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Input 16777 (Approx 0.005V)", test_num);
        binary_input = 24'd16777;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Input 1 (LSB)", test_num);
        binary_input = 24'd1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_24bit Testbench");
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
        input [31:0] expected_analog_output;
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
