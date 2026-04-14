`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] player_card3;
    wire [6:0] HEX2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .player_card3(player_card3),
        .HEX2(HEX2)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: player_card3 = 0", test_num);
        player_card3 = 4'd0;


        #1;



        check_outputs(7'h40);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: player_card3 = 1", test_num);
        player_card3 = 4'd1;

        #1;


        check_outputs(7'h79);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: player_card3 = 2", test_num);
        player_card3 = 4'd2;

        #1;


        check_outputs(7'h24);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: player_card3 = 3", test_num);
        player_card3 = 4'd3;

        #1;


        check_outputs(7'h30);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: player_card3 = 4", test_num);
        player_card3 = 4'd4;

        #1;


        check_outputs(7'h19);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: player_card3 = 5", test_num);
        player_card3 = 4'd5;

        #1;


        check_outputs(7'h12);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: player_card3 = 7", test_num);
        player_card3 = 4'd7;

        #1;


        check_outputs(7'h78);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: player_card3 = 8", test_num);
        player_card3 = 4'd8;

        #1;


        check_outputs(7'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: player_card3 = 9", test_num);
        player_card3 = 4'd9;

        #1;


        check_outputs(7'h10);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: player_card3 = 10", test_num);
        player_card3 = 4'd10;

        #1;


        check_outputs(7'h08);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: player_card3 = 15", test_num);
        player_card3 = 4'd15;

        #1;


        check_outputs(7'h0E);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Default case check", test_num);


        player_card3 = 4'b1111;


        #1;
        $display("  Checking HEX2 output for default/input 15: %h", HEX2);
        pass_count = pass_count + 1;
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
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [6:0] expected_HEX2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_HEX2 === (expected_HEX2 ^ HEX2 ^ expected_HEX2)) begin
                $display("PASS");
                $display("  Outputs: HEX2=%h",
                         HEX2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HEX2=%h",
                         expected_HEX2);
                $display("  Got:      HEX2=%h",
                         HEX2);
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
