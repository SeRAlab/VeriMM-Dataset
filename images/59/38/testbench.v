`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] pos0;
    reg [1:0] pos1;
    reg [1:0] pos2;
    wire winner;
    wire [1:0] winner_player;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pos0(pos0),
        .pos1(pos1),
        .pos2(pos2),
        .winner(winner),
        .winner_player(winner_player)
    );
    task testcase001;

    begin
        test_num = 1;
        pos0 = 2'b01; pos1 = 2'b01; pos2 = 2'b01;
        #1;

        check_outputs(1'b1, 2'b01);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        pos0 = 2'b10; pos1 = 2'b10; pos2 = 2'b10;
        #1;

        check_outputs(1'b1, 2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        pos0 = 2'b11; pos1 = 2'b11; pos2 = 2'b11;
        #1;

        check_outputs(1'b1, 2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        pos0 = 2'b00; pos1 = 2'b00; pos2 = 2'b00;
        #1;

        check_outputs(1'b0, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        pos0 = 2'b01; pos1 = 2'b10; pos2 = 2'b11;
        #1;

        check_outputs(1'b0, 2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        pos0 = 2'b01; pos1 = 2'b01; pos2 = 2'b10;
        #1;

        check_outputs(1'b0, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        pos0 = 2'b11; pos1 = 2'b01; pos2 = 2'b11;
        #1;

        check_outputs(1'b0, 2'b00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        pos0 = 2'b00; pos1 = 2'b10; pos2 = 2'b10;
        #1;

        check_outputs(1'b0, 2'b00);
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
        input expected_winner;
        input [1:0] expected_winner_player;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_winner === (expected_winner ^ winner ^ expected_winner) &&
                expected_winner_player === (expected_winner_player ^ winner_player ^ expected_winner_player)) begin
                $display("PASS");
                $display("  Outputs: winner=%b, winner_player=%h",
                         winner, winner_player);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: winner=%b, winner_player=%h",
                         expected_winner, expected_winner_player);
                $display("  Got:      winner=%b, winner_player=%h",
                         winner, winner_player);
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
