`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg apple;
    reg banana;
    reg carrot;
    reg clk;
    reg date;
    reg dime;
    reg nickel;
    reg penny;
    reg quarter;
    reg reset;
    wire [7:0] credit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .apple(apple),
        .banana(banana),
        .carrot(carrot),
        .clk(clk),
        .date(date),
        .dime(dime),
        .nickel(nickel),
        .penny(penny),
        .quarter(quarter),
        .reset(reset),
        .credit(credit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clear_inputs();
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task clear_inputs;

        begin
            apple = 0; banana = 0; carrot = 0; date = 0;
            dime = 0; nickel = 0; penny = 0; quarter = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: System Reset", test_num);
            reset_dut();
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Individual Coin Insertion (1, 5, 10, 25)", test_num);
            reset_dut();

            penny = 1;   @(posedge clk); penny = 0;
            nickel = 1;  @(posedge clk); nickel = 0;
            dime = 1;    @(posedge clk); dime = 0;
            quarter = 1; @(posedge clk); quarter = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd41);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Item Purchase (Apple)", test_num);
            reset_dut();


            quarter = 1; @(posedge clk); quarter = 0;

            @(posedge clk);
            apple = 1; @(posedge clk); apple = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Item Purchases", test_num);
            reset_dut();


            quarter = 1; repeat(4) @(posedge clk); quarter = 0;


            @(posedge clk);
            banana = 1; @(posedge clk); banana = 0;
            carrot = 1; @(posedge clk); carrot = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Credit Saturation (255)", test_num);
            reset_dut();


            quarter = 1; repeat(10) @(posedge clk); quarter = 0;

            dime = 1; @(posedge clk); dime = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Exhausting Credit to Zero", test_num);
            reset_dut();


            quarter = 1; repeat(2) @(posedge clk); quarter = 0;

            @(posedge clk);
            date = 1; @(posedge clk); date = 0;
            apple = 1; @(posedge clk); apple = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_credit;
        begin
            if (expected_credit === (expected_credit ^ credit ^ expected_credit)) begin
                $display("PASS");
                $display("  Outputs: credit=%h",
                         credit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: credit=%h",
                         expected_credit);
                $display("  Got:      credit=%h",
                         credit);
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
        $dumpvars(0,apple, banana, carrot, clk, date, dime, nickel, penny, quarter, reset, credit);
    end

endmodule
