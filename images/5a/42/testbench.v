`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLK;
    reg iRST_N;
    wire [7:0] LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLK(iCLK),
        .iRST_N(iRST_N),
        .LED(LED)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

        begin
            iRST_N = 0;
            repeat(2) @(posedge iCLK);
            #1;
            iRST_N = 1;
            @(posedge iCLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(8'b0000_0001);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            repeat(3) @(posedge iCLK);
            #1;

            #1;


            check_outputs(8'b0000_1000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            repeat(7) @(posedge iCLK);
            #1;

            #1;


            check_outputs(8'b1000_0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            repeat(8) @(posedge iCLK);
            #1;

            #1;


            check_outputs(8'b0100_0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            repeat(14) @(posedge iCLK);
            #1;
            #1;

            check_outputs(8'b0000_0001);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            repeat(15) @(posedge iCLK);
            #1;
            #1;

            check_outputs(8'b0000_0010);
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
        input [7:0] expected_LED;
        begin
            if (expected_LED === (expected_LED ^ LED ^ expected_LED)) begin
                $display("PASS");
                $display("  Outputs: LED=%h",
                         LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%h",
                         expected_LED);
                $display("  Got:      LED=%h",
                         LED);
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
        $dumpvars(0,iCLK, iRST_N, LED);
    end

endmodule
