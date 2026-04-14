`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire dead;
    wire enemyActive1;
    wire enemyActive2;
    wire enemyActive3;
    wire enemyActive4;
    wire enemyActive5;
    wire enemyActive6;
    wire isBullet1;
    wire isBullet2;
    wire isBullet3;
    wire isBullet4;
    wire isBullet5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .dead(dead),
        .enemyActive1(enemyActive1),
        .enemyActive2(enemyActive2),
        .enemyActive3(enemyActive3),
        .enemyActive4(enemyActive4),
        .enemyActive5(enemyActive5),
        .enemyActive6(enemyActive6),
        .isBullet1(isBullet1),
        .isBullet2(isBullet2),
        .isBullet3(isBullet3),
        .isBullet4(isBullet4),
        .isBullet5(isBullet5)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1'b1;
            @(posedge clk);
            #1 reset = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d - Basic Synchronous Reset", test_num);
            reset_dut();


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d - Post-Reset Stability (10 Cycles)", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d - Extended Post-Reset Stability (50 Cycles)", test_num);
            reset_dut();
            repeat(50) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running testcase%03d - Consecutive Reset Pulses", test_num);
            reset_dut();
            #2;
            reset_dut();
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_dead;
        input expected_enemyActive1;
        input expected_enemyActive2;
        input expected_enemyActive3;
        input expected_enemyActive4;
        input expected_enemyActive5;
        input expected_enemyActive6;
        input expected_isBullet1;
        input expected_isBullet2;
        input expected_isBullet3;
        input expected_isBullet4;
        input expected_isBullet5;
        begin
            if (expected_dead === (expected_dead ^ dead ^ expected_dead) &&
                expected_enemyActive1 === (expected_enemyActive1 ^ enemyActive1 ^ expected_enemyActive1) &&
                expected_enemyActive2 === (expected_enemyActive2 ^ enemyActive2 ^ expected_enemyActive2) &&
                expected_enemyActive3 === (expected_enemyActive3 ^ enemyActive3 ^ expected_enemyActive3) &&
                expected_enemyActive4 === (expected_enemyActive4 ^ enemyActive4 ^ expected_enemyActive4) &&
                expected_enemyActive5 === (expected_enemyActive5 ^ enemyActive5 ^ expected_enemyActive5) &&
                expected_enemyActive6 === (expected_enemyActive6 ^ enemyActive6 ^ expected_enemyActive6) &&
                expected_isBullet1 === (expected_isBullet1 ^ isBullet1 ^ expected_isBullet1) &&
                expected_isBullet2 === (expected_isBullet2 ^ isBullet2 ^ expected_isBullet2) &&
                expected_isBullet3 === (expected_isBullet3 ^ isBullet3 ^ expected_isBullet3) &&
                expected_isBullet4 === (expected_isBullet4 ^ isBullet4 ^ expected_isBullet4) &&
                expected_isBullet5 === (expected_isBullet5 ^ isBullet5 ^ expected_isBullet5)) begin
                $display("PASS");
                $display("  Outputs: dead=%b, enemyActive1=%b, enemyActive2=%b, enemyActive3=%b, enemyActive4=%b, enemyActive5=%b, enemyActive6=%b, isBullet1=%b, isBullet2=%b, isBullet3=%b, isBullet4=%b, isBullet5=%b",
                         dead, enemyActive1, enemyActive2, enemyActive3, enemyActive4, enemyActive5, enemyActive6, isBullet1, isBullet2, isBullet3, isBullet4, isBullet5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dead=%b, enemyActive1=%b, enemyActive2=%b, enemyActive3=%b, enemyActive4=%b, enemyActive5=%b, enemyActive6=%b, isBullet1=%b, isBullet2=%b, isBullet3=%b, isBullet4=%b, isBullet5=%b",
                         expected_dead, expected_enemyActive1, expected_enemyActive2, expected_enemyActive3, expected_enemyActive4, expected_enemyActive5, expected_enemyActive6, expected_isBullet1, expected_isBullet2, expected_isBullet3, expected_isBullet4, expected_isBullet5);
                $display("  Got:      dead=%b, enemyActive1=%b, enemyActive2=%b, enemyActive3=%b, enemyActive4=%b, enemyActive5=%b, enemyActive6=%b, isBullet1=%b, isBullet2=%b, isBullet3=%b, isBullet4=%b, isBullet5=%b",
                         dead, enemyActive1, enemyActive2, enemyActive3, enemyActive4, enemyActive5, enemyActive6, isBullet1, isBullet2, isBullet3, isBullet4, isBullet5);
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
        $dumpvars(0,clk, reset, dead, enemyActive1, enemyActive2, enemyActive3, enemyActive4, enemyActive5, enemyActive6, isBullet1, isBullet2, isBullet3, isBullet4, isBullet5);
    end

endmodule
