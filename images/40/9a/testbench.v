`timescale 1ns/1ps

module ADC_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] voltage_in;
    wire [7:0] digital_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ADC_8bit dut (
        .voltage_in(voltage_in),
        .digital_out(digital_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Input Voltage = 0V", test_num);
            voltage_in = 3'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input Voltage = 1V", test_num);
            voltage_in = 3'd1;
            #1;

            check_outputs(8'd36);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Input Voltage = 2V", test_num);
            voltage_in = 3'd2;
            #1;

            check_outputs(8'd72);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Input Voltage = 3V", test_num);
            voltage_in = 3'd3;
            #1;

            check_outputs(8'd109);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Input Voltage = 4V", test_num);
            voltage_in = 3'd4;
            #1;

            check_outputs(8'd145);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Input Voltage = 5V", test_num);
            voltage_in = 3'd5;
            #1;

            check_outputs(8'd182);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Input Voltage = 6V", test_num);
            voltage_in = 3'd6;
            #1;

            check_outputs(8'd218);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Input Voltage = 7V (Full Scale)", test_num);
            voltage_in = 3'd7;
            #1;

            check_outputs(8'd255);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ADC_8bit Testbench");
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
        input [7:0] expected_digital_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digital_out === (expected_digital_out ^ digital_out ^ expected_digital_out)) begin
                $display("PASS");
                $display("  Outputs: digital_out=%h",
                         digital_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_out=%h",
                         expected_digital_out);
                $display("  Got:      digital_out=%h",
                         digital_out);
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
