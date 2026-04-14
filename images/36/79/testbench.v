`timescale 1ns/1ps

module temp_sensor_converter_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] temp_in;
    wire [1:0] temp_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temp_sensor_converter dut (
        .temp_in(temp_in),
        .temp_out(temp_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: temp_in = 0 (Low)");
        temp_in = 3'd0;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: temp_in = 1 (Low)");
        temp_in = 3'd1;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: temp_in = 2 (Low)");
        temp_in = 3'd2;
        #1;

        check_outputs(2'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: temp_in = 3 (Medium)");
        temp_in = 3'd3;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: temp_in = 4 (Medium)");
        temp_in = 3'd4;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: temp_in = 5 (Medium)");
        temp_in = 3'd5;
        #1;

        check_outputs(2'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: temp_in = 6 (High)");
        temp_in = 3'd6;
        #1;

        check_outputs(2'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: temp_in = 7 (High)");
        temp_in = 3'd7;
        #1;

        check_outputs(2'd2);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temp_sensor_converter Testbench");
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
        input [1:0] expected_temp_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_temp_out === (expected_temp_out ^ temp_out ^ expected_temp_out)) begin
                $display("PASS");
                $display("  Outputs: temp_out=%h",
                         temp_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temp_out=%h",
                         expected_temp_out);
                $display("  Got:      temp_out=%h",
                         temp_out);
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
