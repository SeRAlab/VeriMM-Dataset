`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ADDR;
    reg WE;
    wire [3:0] mem_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR(ADDR),
        .WE(WE),
        .mem_data(mem_data)
    );

    // Clock generation (10ns period)
    initial begin
        WE = 0;
        forever #5 WE = ~WE;
    end

        task reset_dut;

        begin
            ADDR = 0;
            DATA_reg = 0;

            @(negedge WE);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            ADDR = 4'd0;
            @(negedge WE);
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            ADDR = 4'd7;
            @(negedge WE);
            #2;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            ADDR = 4'd14;
            @(negedge WE);
            #2;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            ADDR = 4'd5;
            DATA_reg = 4'hA;
            @(posedge WE);
            #1;
            @(negedge WE);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            ADDR = 4'd15;
            DATA_reg = 4'hE;
            @(posedge WE);
            #1;
            @(negedge WE);
            #2;
            #1;

            check_outputs(4'hE);
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
        input [3:0] expected_mem_data;
        begin
            if (expected_mem_data === (expected_mem_data ^ mem_data ^ expected_mem_data)) begin
                $display("PASS");
                $display("  Outputs: mem_data=%h",
                         mem_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_data=%h",
                         expected_mem_data);
                $display("  Got:      mem_data=%h",
                         mem_data);
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
        $dumpvars(0,ADDR, WE, mem_data);
    end

endmodule
