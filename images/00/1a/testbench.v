`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] voltage_input;
    wire [4:0] voltage_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .voltage_input(voltage_input),
        .voltage_output(voltage_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Input 000 (0V)", test_num);
            voltage_input = 3'b000;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Input 001 (1V)", test_num);
            voltage_input = 3'b001;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Input 010 (2V)", test_num);
            voltage_input = 3'b010;
            #1;

            check_outputs(5'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Input 011 (3V)", test_num);
            voltage_input = 3'b011;
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Input 100 (4V)", test_num);
            voltage_input = 3'b100;
            #1;

            check_outputs(5'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Input 101 (Continuing proportionality - 5V)", test_num);
            voltage_input = 3'b101;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Input 110 (Continuing proportionality - 6V)", test_num);
            voltage_input = 3'b110;
            #1;

            check_outputs(5'd6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Input 111 (Continuing proportionality - 7V)", test_num);
            voltage_input = 3'b111;
            #1;

            check_outputs(5'd7);
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
        input [4:0] expected_voltage_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_voltage_output === (expected_voltage_output ^ voltage_output ^ expected_voltage_output)) begin
                $display("PASS");
                $display("  Outputs: voltage_output=%h",
                         voltage_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: voltage_output=%h",
                         expected_voltage_output);
                $display("  Got:      voltage_output=%h",
                         voltage_output);
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
