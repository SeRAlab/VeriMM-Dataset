`timescale 1ns/1ps

module LDO_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] control;
    wire [2:0] output_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO dut (
        .control(control),
        .output_voltage(output_voltage)
    );
    task testcase001;

        begin
            $display("Testcase 001: Testing control = 3'b000 (Min Voltage)");
            control = 3'b000;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Testing control = 3'b001");
            control = 3'b001;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Testing control = 3'b010");
            control = 3'b010;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Testing control = 3'b011");
            control = 3'b011;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Testing control = 3'b100 (Mid-range)");
            control = 3'b100;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Testing control = 3'b101");
            control = 3'b101;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Testing control = 3'b110");
            control = 3'b110;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Testing control = 3'b111 (Max Voltage)");
            control = 3'b111;
            #1;

            check_outputs(3'b111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO Testbench");
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
        input [2:0] expected_output_voltage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_voltage === (expected_output_voltage ^ output_voltage ^ expected_output_voltage)) begin
                $display("PASS");
                $display("  Outputs: output_voltage=%h",
                         output_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_voltage=%h",
                         expected_output_voltage);
                $display("  Got:      output_voltage=%h",
                         output_voltage);
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
