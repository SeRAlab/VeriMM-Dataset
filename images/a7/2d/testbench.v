`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] pos0;
    reg [1:0] pos1;
    reg [1:0] pos2;
    wire [1:0] who;
    wire winner;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pos0(pos0),
        .pos1(pos1),
        .pos2(pos2),
        .who(who),
        .winner(winner)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No winners (all zeros)", test_num);
            pos0 = 2'b00;
            pos1 = 2'b00;
            pos2 = 2'b00;
            #1;

            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Position 0 is winner (2'b11)", test_num);
            pos0 = 2'b11;
            pos1 = 2'b01;
            pos2 = 2'b10;
            #1;

            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Position 1 is winner (2'b11)", test_num);
            pos0 = 2'b01;
            pos1 = 2'b11;
            pos2 = 2'b00;
            #1;

            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Position 2 is winner (2'b11)", test_num);
            pos0 = 2'b10;
            pos1 = 2'b01;
            pos2 = 2'b11;
            #1;

            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed bits, no 2'b11 match", test_num);
            pos0 = 2'b10;
            pos1 = 2'b01;
            pos2 = 2'b10;
            #1;

            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple winners (0 and 1), checking priority", test_num);
            pos0 = 2'b11;
            pos1 = 2'b11;
            pos2 = 2'b00;

            #1;


            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple winners (1 and 2), checking priority", test_num);
            pos0 = 2'b00;
            pos1 = 2'b11;
            pos2 = 2'b11;
            #1;

            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All positions meet criteria", test_num);
            pos0 = 2'b11;
            pos1 = 2'b11;
            pos2 = 2'b11;
            #1;

            check_outputs(2'b00, 1'b1);
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
        input [1:0] expected_who;
        input expected_winner;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_who === (expected_who ^ who ^ expected_who) &&
                expected_winner === (expected_winner ^ winner ^ expected_winner)) begin
                $display("PASS");
                $display("  Outputs: who=%h, winner=%b",
                         who, winner);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: who=%h, winner=%b",
                         expected_who, expected_winner);
                $display("  Got:      who=%h, winner=%b",
                         who, winner);
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
