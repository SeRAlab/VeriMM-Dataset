`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg move_down;
    reg move_up;
    wire [1:0] at_floor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .move_down(move_down),
        .move_up(move_up),
        .at_floor(at_floor)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            move_up = 0;
            move_down = 0;
            #15;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Start Reset...");
            reset_dut();
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Ground to First Floor...");
            reset_dut();
            @(negedge clk);
            move_up = 1;
            @(posedge clk);
            #1;
            move_up = 0;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Ground to Second Floor...");
            reset_dut();
            @(negedge clk);
            move_up = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            move_up = 0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Second to Ground Floor...");
            reset_dut();

            @(negedge clk);
            move_up = 1;
            repeat(2) @(posedge clk);

            @(negedge clk);
            move_up = 0;
            move_down = 1;
            repeat(2) @(posedge clk);
            #1;
            move_down = 0;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Move Up while at Second Floor...");
            reset_dut();

            @(negedge clk);
            move_up = 1;
            repeat(2) @(posedge clk);

            @(posedge clk);
            #1;
            move_up = 0;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Move Down while at Ground Floor...");
            reset_dut();
            @(negedge clk);
            move_down = 1;
            @(posedge clk);
            #1;
            move_down = 0;
            #1;

            check_outputs(2'b00);
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
        input [1:0] expected_at_floor;
        begin
            if (expected_at_floor === (expected_at_floor ^ at_floor ^ expected_at_floor)) begin
                $display("PASS");
                $display("  Outputs: at_floor=%h",
                         at_floor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: at_floor=%h",
                         expected_at_floor);
                $display("  Got:      at_floor=%h",
                         at_floor);
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
        $dumpvars(0,areset, clk, move_down, move_up, at_floor);
    end

endmodule
