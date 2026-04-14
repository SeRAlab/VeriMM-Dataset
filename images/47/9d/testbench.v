`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] DataIN;
    reg Reset_b;
    reg clock;
    wire [7:0] DataOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DataIN(DataIN),
        .Reset_b(Reset_b),
        .clock(clock),
        .DataOUT(DataOUT)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(negedge clock);
            Reset_b = 0;
            DataIN = 8'h00;
            @(negedge clock);
            Reset_b = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset functionality", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 0xAA", test_num);
            reset_dut();
            @(negedge clock);
            DataIN = 8'hAA;
            @(negedge clock);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 0x55", test_num);
            reset_dut();
            @(negedge clock);
            DataIN = 8'h55;
            @(negedge clock);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset priority over DataIN", test_num);
            reset_dut();
            @(negedge clock);
            DataIN = 8'hFF;
            Reset_b = 0;
            @(negedge clock);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 0xFF", test_num);
            reset_dut();
            @(negedge clock);
            DataIN = 8'hFF;
            @(negedge clock);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Output stability", test_num);
            reset_dut();
            @(negedge clock);
            DataIN = 8'h3C;
            @(negedge clock);
            DataIN = 8'hA5;



            @(negedge clock);
            #1;

            check_outputs(8'hA5);
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
        input [7:0] expected_DataOUT;
        begin
            if (expected_DataOUT === (expected_DataOUT ^ DataOUT ^ expected_DataOUT)) begin
                $display("PASS");
                $display("  Outputs: DataOUT=%h",
                         DataOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DataOUT=%h",
                         expected_DataOUT);
                $display("  Got:      DataOUT=%h",
                         DataOUT);
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
        $dumpvars(0,DataIN, Reset_b, clock, DataOUT);
    end

endmodule
