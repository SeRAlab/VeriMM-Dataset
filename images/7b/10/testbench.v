`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] address;
    reg clock;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address <= 0;
            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address = 0 (Lower Range)", test_num);
            reset_dut();
            address <= 12'd0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(12'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address = 1000 (Lower Range)", test_num);
            reset_dut();
            address <= 12'd1000;
            @(posedge clock);
            #2;
            #1;

            check_outputs(12'd1100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address = 2047 (Boundary < 2048)", test_num);
            reset_dut();
            address <= 12'd2047;
            @(posedge clock);
            #2;
            #1;

            check_outputs(12'd2147);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address = 2048 (Boundary >= 2048)", test_num);
            reset_dut();
            address <= 12'd2048;
            @(posedge clock);
            #2;
            #1;

            check_outputs(12'd1948);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address = 3000 (Upper Range)", test_num);
            reset_dut();
            address <= 12'd3000;
            @(posedge clock);
            #2;
            #1;

            check_outputs(12'd2900);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address = 4095 (Upper Boundary)", test_num);
            reset_dut();
            address <= 12'd4095;
            @(posedge clock);
            #2;
            #1;

            check_outputs(12'd3995);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive Operations Check", test_num);
            reset_dut();


            address <= 12'd500;
            @(posedge clock);
            #2;


            address <= 12'd3000;
            @(posedge clock);
            #2;

            #1;


            check_outputs(12'd2900);
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
        input [11:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,address, clock, q);
    end

endmodule
