`timescale 1ns/1ps

module power_gating_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_input;
    reg power_control;
    wire [3:0] data_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_gating dut (
        .data_input(data_input),
        .power_control(power_control),
        .data_output(data_output)
    );
    task testcase001;

        begin
            $display("Test Case 001: Power Control ON, Data Input = 4'hA");
            power_control = 1;
            data_input = 4'hA;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Power Control OFF, Data Input = 4'hA");
            power_control = 0;
            data_input = 4'hA;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Power Control ON, Data Input = 4'hF");
            power_control = 1;
            data_input = 4'hF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Power Control OFF, Data Input = 4'hF");
            power_control = 0;
            data_input = 4'hF;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Power Control ON, Data Input = 4'h0");
            power_control = 1;
            data_input = 4'h0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("power_gating Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [3:0] expected_data_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_output === (expected_data_output ^ data_output ^ expected_data_output)) begin
                $display("PASS");
                $display("  Outputs: data_output=%h",
                         data_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_output=%h",
                         expected_data_output);
                $display("  Got:      data_output=%h",
                         data_output);
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
