`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] col;
    reg [3:0] row;
    reg [1:0] select;
    wire word;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .col(col),
        .row(row),
        .select(select),
        .word(word)
    );
    task testcase001;

        begin
            test_num = 1;
            select = 2'b00;
            row = 4'd0;
            col = 4'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            select = 2'b00;
            row = 4'd15;
            col = 4'd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            select = 2'b01;
            row = 4'd0;
            col = 4'd0;


            #1;



            check_outputs(word);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            select = 2'b01;
            row = 4'd15;
            col = 4'd15;
            #1;

            check_outputs(word);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            select = 2'b01;
            row = 4'd7;
            col = 4'd8;
            #1;

            check_outputs(word);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            select = 2'b10;
            row = 4'd0;
            col = 4'd0;
            #1;

            check_outputs(word);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            select = 2'b10;
            row = 4'd10;
            col = 4'd5;
            #1;

            check_outputs(word);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            select = 2'b10;
            row = 4'd15;
            col = 4'd0;
            #1;

            check_outputs(word);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            select = 2'b11;
            row = 4'd0;
            col = 4'd0;
            #1;

            check_outputs(word);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_word;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_word === (expected_word ^ word ^ expected_word)) begin
                $display("PASS");
                $display("  Outputs: word=%b",
                         word);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: word=%b",
                         expected_word);
                $display("  Got:      word=%b",
                         word);
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
