`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] voltage_in;
    wire [1:0] voltage_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .voltage_in(voltage_in),
        .voltage_out(voltage_out)
    );
    task testcase001;

        begin
            $display("Test Case 001: Input 000 (0V)");
            test_num = 1;
            voltage_in = 3'b000;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input 001 (1V)");
            test_num = 2;
            voltage_in = 3'b001;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Input 010 (2V)");
            test_num = 3;
            voltage_in = 3'b010;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Input 011 (2V)");
            test_num = 4;
            voltage_in = 3'b011;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Input 100 (3V)");
            test_num = 5;
            voltage_in = 3'b100;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Input 101 (3V)");
            test_num = 6;
            voltage_in = 3'b101;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Input 110 (3V)");
            test_num = 7;
            voltage_in = 3'b110;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Input 111 (3V)");
            test_num = 8;
            voltage_in = 3'b111;
            #1;

            check_outputs(2'b11);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_regulator Testbench");
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
        input [1:0] expected_voltage_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_voltage_out === (expected_voltage_out ^ voltage_out ^ expected_voltage_out)) begin
                $display("PASS");
                $display("  Outputs: voltage_out=%h",
                         voltage_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage_out=%h",
                         expected_voltage_out);
                $display("  Got:      voltage_out=%h",
                         voltage_out);
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
