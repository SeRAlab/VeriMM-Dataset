`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg coin;
    reg dime;
    reg nickel;
    reg reset;
    wire vend_coke;
    wire vend_pepsi;
    wire vend_soda;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .coin(coin),
        .dime(dime),
        .nickel(nickel),
        .reset(reset),
        .vend_coke(vend_coke),
        .vend_pepsi(vend_pepsi),
        .vend_soda(vend_soda)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            coin = 0;
            dime = 0;
            nickel = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial state check after reset");
            reset_dut();
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Vend Coke (Dime)");
            reset_dut();
            dime = 1;
            @(posedge clk);
            dime = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Vend Pepsi (Nickel)");
            reset_dut();
            nickel = 1;
            @(posedge clk);
            nickel = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Vend Soda (Coin)");
            reset_dut();
            coin = 1;
            @(posedge clk);
            coin = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Return to IDLE after dispensing Coke");
            reset_dut();
            dime = 1;
            @(posedge clk);
            dime = 0;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: No input check");
            reset_dut();
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Reset during dispensing state");
            reset_dut();
            coin = 1;
            @(posedge clk);
            coin = 0;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 0);
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
        input expected_vend_coke;
        input expected_vend_pepsi;
        input expected_vend_soda;
        begin
            if (expected_vend_coke === (expected_vend_coke ^ vend_coke ^ expected_vend_coke) &&
                expected_vend_pepsi === (expected_vend_pepsi ^ vend_pepsi ^ expected_vend_pepsi) &&
                expected_vend_soda === (expected_vend_soda ^ vend_soda ^ expected_vend_soda)) begin
                $display("PASS");
                $display("  Outputs: vend_coke=%b, vend_pepsi=%b, vend_soda=%b",
                         vend_coke, vend_pepsi, vend_soda);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vend_coke=%b, vend_pepsi=%b, vend_soda=%b",
                         expected_vend_coke, expected_vend_pepsi, expected_vend_soda);
                $display("  Got:      vend_coke=%b, vend_pepsi=%b, vend_soda=%b",
                         vend_coke, vend_pepsi, vend_soda);
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
        $dumpvars(0,clk, coin, dime, nickel, reset, vend_coke, vend_pepsi, vend_soda);
    end

endmodule
