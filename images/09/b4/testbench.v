`timescale 1ns/1ps

module temperature_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] temp_input;
    wire [2:0] status_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor dut (
        .temp_input(temp_input),
        .status_output(status_output)
    );
    task testcase001;

    begin
        $display("Test Case 001: Temp = 0 (Below 2)");
        test_num = test_num + 1;
        temp_input = 3'd0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Temp = 1 (Below 2)");
        test_num = test_num + 1;
        temp_input = 3'd1;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Temp = 2 (Between 2 and 4)");
        test_num = test_num + 1;
        temp_input = 3'd2;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Temp = 3 (Between 2 and 4)");
        test_num = test_num + 1;
        temp_input = 3'd3;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Temp = 4 (Between 2 and 4)");
        test_num = test_num + 1;
        temp_input = 3'd4;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Temp = 5 (Between 5 and 6)");
        test_num = test_num + 1;
        temp_input = 3'd5;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Temp = 6 (Between 5 and 6)");
        test_num = test_num + 1;
        temp_input = 3'd6;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Temp = 7 (Is 7)");
        test_num = test_num + 1;
        temp_input = 3'd7;
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
        $display("temperature_sensor Testbench");
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
        input [2:0] expected_status_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_status_output === (expected_status_output ^ status_output ^ expected_status_output)) begin
                $display("PASS");
                $display("  Outputs: status_output=%h",
                         status_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status_output=%h",
                         expected_status_output);
                $display("  Got:      status_output=%h",
                         status_output);
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
