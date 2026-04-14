`timescale 1ns/1ps

module DAC_24bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] V_ref;
    reg [23:0] binary_input;
    wire [15:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_24bit dut (
        .V_ref(V_ref),
        .binary_input(binary_input),
        .analog_output(analog_output)
    );
    task testcase001;

        begin
            V_ref = 16'd5000;
            binary_input = 24'd0;
            $display("Test 001: Zero Input (V_ref=%d, Input=%d)", V_ref, binary_input);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            V_ref = 16'hFFFF;
            binary_input = 24'hFFFFFF;
            $display("Test 002: Full Scale Input (V_ref=%d, Input=%h)", V_ref, binary_input);

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            V_ref = 16'd10000;
            binary_input = 24'h800000;
            $display("Test 003: Midpoint Input (V_ref=%d, Input=%h)", V_ref, binary_input);

            #1;


            check_outputs(16'd5000);
        end
        endtask

    task testcase004;

        begin
            V_ref = 16'd20000;
            binary_input = 24'h400000;
            $display("Test 004: Quarter Scale Input (V_ref=%d, Input=%h)", V_ref, binary_input);

            #1;


            check_outputs(16'd5000);
        end
        endtask

    task testcase005;

        begin
            V_ref = 16'd0;
            binary_input = 24'hFFFFFF;
            $display("Test 005: Zero Reference Voltage (V_ref=0, Input=MAX)");
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase006;

        begin
            V_ref = 16'd4096;
            binary_input = 24'd1234567;
            $display("Test 006: Arbitrary Input (V_ref=%d, Input=%d)", V_ref, binary_input);

            #1;


            check_outputs(16'd301);
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
        input [15:0] expected_analog_output;
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
