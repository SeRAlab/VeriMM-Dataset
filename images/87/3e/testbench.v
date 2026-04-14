`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] bits;
    wire active;
    wire [2:0] position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bits(bits),
        .active(active),
        .position(position)
    );
    task testcase001;

    begin
        test_num = 1;
        bits = 8'b00000000;
        #1;

        check_outputs(1'b0, 3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        bits = 8'b00000001;
        #1;

        check_outputs(1'b1, 3'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        bits = 8'b00000010;
        #1;

        check_outputs(1'b1, 3'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        bits = 8'b00001100;
        #1;

        check_outputs(1'b1, 3'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        bits = 8'b00001000;
        #1;

        check_outputs(1'b1, 3'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        bits = 8'b11110000;
        #1;

        check_outputs(1'b1, 3'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        bits = 8'b01100000;
        #1;

        check_outputs(1'b1, 3'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        bits = 8'b01000000;
        #1;

        check_outputs(1'b1, 3'd6);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        bits = 8'b10000000;
        #1;

        check_outputs(1'b1, 3'd7);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        bits = 8'b11111111;
        #1;

        check_outputs(1'b1, 3'd0);
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
        input expected_active;
        input [2:0] expected_position;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_active === (expected_active ^ active ^ expected_active) &&
                expected_position === (expected_position ^ position ^ expected_position)) begin
                $display("PASS");
                $display("  Outputs: active=%b, position=%h",
                         active, position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active=%b, position=%h",
                         expected_active, expected_position);
                $display("  Got:      active=%b, position=%h",
                         active, position);
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
