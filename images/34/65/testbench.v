`timescale 1ns/1ps

module sd_card_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] command;
    wire [1:0] operation;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_decoder dut (
        .command(command),
        .operation(operation)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: No Operation (0000)", test_num);
            command = 4'b0000;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Read Request (0001)", test_num);
            command = 4'b0001;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Write Request (0010)", test_num);
            command = 4'b0010;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Erase Request (0011)", test_num);
            command = 4'b0011;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Initialize Request (0100)", test_num);
            command = 4'b0100;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Undefined Command (0101)", test_num);
            command = 4'b0101;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Boundary Undefined Command (1111)", test_num);
            command = 4'b1111;
            #1;

            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_decoder Testbench");
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
        input [1:0] expected_operation;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_operation === (expected_operation ^ operation ^ expected_operation)) begin
                $display("PASS");
                $display("  Outputs: operation=%h",
                         operation);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: operation=%h",
                         expected_operation);
                $display("  Got:      operation=%h",
                         operation);
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
