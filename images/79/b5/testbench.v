`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clockIN;
    reg rxIN;
    wire rxOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clockIN(clockIN),
        .rxIN(rxIN),
        .rxOUT(rxOUT)
    );

    // Clock generation (10ns period)
    initial begin
        clockIN = 0;
        forever #5 clockIN = ~clockIN;
    end

        task reset_dut;

    begin
        rxIN = 0;
        repeat(4) @(posedge clockIN);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        @(negedge clockIN) rxIN = 0;
        @(negedge clockIN) rxIN = 0;
        @(negedge clockIN) rxIN = 0;
        @(posedge clockIN);
        #2 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(negedge clockIN) rxIN = 1;
        @(negedge clockIN) rxIN = 1;
        @(negedge clockIN) rxIN = 1;
        @(posedge clockIN);
        #2 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        @(negedge clockIN) rxIN = 1;
        @(negedge clockIN) rxIN = 1;
        @(negedge clockIN) rxIN = 0;
        @(posedge clockIN);
        #2 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        @(negedge clockIN) rxIN = 0;
        @(negedge clockIN) rxIN = 0;
        @(negedge clockIN) rxIN = 1;
        @(posedge clockIN);
        #2 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        @(negedge clockIN) rxIN = 1;
        @(negedge clockIN) rxIN = 0;
        @(negedge clockIN) rxIN = 1;
        @(posedge clockIN);
        #2 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        @(negedge clockIN) rxIN = 0;
        @(negedge clockIN) rxIN = 1;
        @(negedge clockIN) rxIN = 0;
        @(posedge clockIN);
        #2 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        @(negedge clockIN) rxIN = 0;
        @(negedge clockIN) rxIN = 1;
        @(negedge clockIN) rxIN = 1;
        @(posedge clockIN);
        #2 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        @(negedge clockIN) rxIN = 1;
        @(negedge clockIN) rxIN = 0;
        @(negedge clockIN) rxIN = 0;
        @(posedge clockIN);
        #2 #1;
 check_outputs(1'b0);
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
        testcase008();
        
        
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
        input expected_rxOUT;
        begin
            if (expected_rxOUT === (expected_rxOUT ^ rxOUT ^ expected_rxOUT)) begin
                $display("PASS");
                $display("  Outputs: rxOUT=%b",
                         rxOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rxOUT=%b",
                         expected_rxOUT);
                $display("  Got:      rxOUT=%b",
                         rxOUT);
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
        $dumpvars(0,clockIN, rxIN, rxOUT);
    end

endmodule
