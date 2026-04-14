`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] choose_1;
    reg [4:0] choose_2;
    reg east;
    reg new_clk;
    reg rst;
    reg west;
    wire [4:0] point;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .choose_1(choose_1),
        .choose_2(choose_2),
        .east(east),
        .new_clk(new_clk),
        .rst(rst),
        .west(west),
        .point(point)
    );

    // Clock generation (10ns period)
    initial begin
        new_clk = 0;
        forever #5 new_clk = ~new_clk;
    end

        task reset_dut;

        begin
            rst = 1;
            east = 0;
            west = 0;
            choose_1 = 5'h1F;
            choose_2 = 5'h00;
            @(posedge new_clk);
            #1 rst = 0;
            @(posedge new_clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: East Movement (Normal Step)");
            reset_dut();
            east = 1;
            choose_1 = 5'd10;
            @(posedge new_clk);
            east = 0;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: West Movement from middle value");
            reset_dut();

            repeat(5) begin
                east = 1; @(posedge new_clk);
            end
            east = 0;

            west = 1;
            choose_1 = 5'd10;
            @(posedge new_clk);
            west = 0;
            #1;

            check_outputs(5'd4);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: East Wrap-around (15 to 0)");
            reset_dut();
            choose_1 = 5'd20;
            east = 1;
            repeat(15) @(posedge new_clk);
            @(posedge new_clk);
            east = 0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: West Wrap-around (0 to 15)");
            reset_dut();
            choose_1 = 5'd20;
            west = 1;
            @(posedge new_clk);
            west = 0;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Jump Step (choose_1 condition)");
            reset_dut();
            choose_1 = 5'd0;
            east = 1;
            @(posedge new_clk);
            east = 0;
            #1;

            check_outputs(5'd2);
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
        input [4:0] expected_point;
        begin
            if (expected_point === (expected_point ^ point ^ expected_point)) begin
                $display("PASS");
                $display("  Outputs: point=%h",
                         point);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: point=%h",
                         expected_point);
                $display("  Got:      point=%h",
                         point);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,choose_1, choose_2, east, new_clk, rst, west, point);
    end

endmodule
