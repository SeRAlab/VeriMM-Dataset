`timescale 1ns/1ps

module sd_card_interface_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] command;
    wire [3:0] response;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_interface dut (
        .command(command),
        .response(response)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Command = 0");
            command = 4'd0;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Command = 1");
            command = 4'd1;
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Command = 2");
            command = 4'd2;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Command = 3");
            command = 4'd3;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Command = 4");
            command = 4'd4;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Command = 10");
            command = 4'd10;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Command = 15");
            command = 4'd15;
            #1;

            check_outputs(4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_interface Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_response;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_response === (expected_response ^ response ^ expected_response)) begin
                $display("PASS");
                $display("  Outputs: response=%h",
                         response);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: response=%h",
                         expected_response);
                $display("  Got:      response=%h",
                         response);
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
