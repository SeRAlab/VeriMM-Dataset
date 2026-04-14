`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] height;
    reg rst;
    wire game_pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .height(height),
        .rst(rst),
        .game_pulse(game_pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            height = 4'd0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Height 4 Interval", test_num);
            reset_dut();
            height = 4'd4;

            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Height 10 Interval", test_num);
            reset_dut();
            height = 4'd10;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Change Height Mid-Count", test_num);
            reset_dut();
            height = 4'd12;
            repeat(6) @(posedge clk);


            height = 4'd2;
            @(posedge clk);
            #1;


            if (game_pulse == 1'b0) begin

                repeat(2) @(posedge clk);
                #1;
                #1;

                check_outputs(1'b1);
            end else begin
                $display("FAIL: Pulse should have been cleared on height change");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Manual Reset during Pulse", test_num);
            reset_dut();
            height = 4'd5;
            repeat(5) @(posedge clk);
            #1;
            if (game_pulse == 1'b1) begin
                rst = 1;
                @(posedge clk);
                #1;
                #1;

                check_outputs(1'b0);
                rst = 0;
            end else begin
                $display("FAIL: Pulse did not trigger, cannot test reset clear");
                fail_count = fail_count + 1;
            end
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
        input expected_game_pulse;
        begin
            if (expected_game_pulse === (expected_game_pulse ^ game_pulse ^ expected_game_pulse)) begin
                $display("PASS");
                $display("  Outputs: game_pulse=%b",
                         game_pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: game_pulse=%b",
                         expected_game_pulse);
                $display("  Got:      game_pulse=%b",
                         game_pulse);
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
        $dumpvars(0,clk, height, rst, game_pulse);
    end

endmodule
