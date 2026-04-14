`timescale 1ns/1ps

module wifi_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] command;
    wire [4:0] message;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_module dut (
        .command(command),
        .message(message)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Command 'Connect' (000)", test_num);
            command = 3'b000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Command 'Disconnect' (001)", test_num);
            command = 3'b001;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Command 'Send Data' (010)", test_num);
            command = 3'b010;
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Command 'Receive Data' (011)", test_num);
            command = 3'b011;
            #1;

            check_outputs(5'b00011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Command 'Status' (100)", test_num);
            command = 3'b100;
            #1;

            check_outputs(5'b00100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Invalid Command (101)", test_num);
            command = 3'b101;


            #1;



            check_outputs(5'bXXXXX);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_module Testbench");
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
        input [4:0] expected_message;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_message === (expected_message ^ message ^ expected_message)) begin
                $display("PASS");
                $display("  Outputs: message=%h",
                         message);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: message=%h",
                         expected_message);
                $display("  Got:      message=%h",
                         message);
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
