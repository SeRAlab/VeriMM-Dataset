`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] rd_addr;
    wire [15:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .rd_addr(rd_addr),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            rd_addr = 4'b0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Read Address 0", test_num);
            reset_dut();
            rd_addr = 4'd0;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Read Address 1", test_num);
            reset_dut();
            rd_addr = 4'd1;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Read Address 7", test_num);
            reset_dut();
            rd_addr = 4'd7;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h7777);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Read Address 15", test_num);
            reset_dut();
            rd_addr = 4'd15;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Read Invalid Address (X)", test_num);
            reset_dut();
            rd_addr = 4'bxxxx;
            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_rd_data;
        begin
            if (expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: rd_data=%h",
                         rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data=%h",
                         expected_rd_data);
                $display("  Got:      rd_data=%h",
                         rd_data);
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
        $dumpvars(0,clock, rd_addr, rd_data);
    end

endmodule
