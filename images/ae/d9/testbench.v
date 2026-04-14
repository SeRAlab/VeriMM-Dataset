`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] ain;
    reg clock;
    reg reset;
    wire yout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ain(ain),
        .clock(clock),
        .reset(reset),
        .yout(yout)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            ain = 2'b00;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset behavior (Initial State S0)", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence 2'b01 -> 2'b10", test_num);
            reset_dut();
            ain = 2'b01; @(posedge clock); #1;
            ain = 2'b10; @(posedge clock); #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence 2'b01 -> 2'b11 -> 2'b11", test_num);
            reset_dut();
            ain = 2'b01; @(posedge clock); #1;
            ain = 2'b11; @(posedge clock); #1;
            ain = 2'b11; @(posedge clock); #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex sequence 00 -> 01 -> 10 -> 11 -> 01", test_num);
            reset_dut();
            ain = 2'b00; @(posedge clock); #1;
            ain = 2'b01; @(posedge clock); #1;
            ain = 2'b10; @(posedge clock); #1;
            ain = 2'b11; @(posedge clock); #1;
            ain = 2'b01; @(posedge clock); #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Repeated input 2'b11 sequence", test_num);
            reset_dut();
            ain = 2'b11; @(posedge clock); #1;
            ain = 2'b11; @(posedge clock); #1;
            ain = 2'b11; @(posedge clock); #1;
            ain = 2'b11; @(posedge clock); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-sequence reset", test_num);
            reset_dut();
            ain = 2'b01; @(posedge clock); #1;
            ain = 2'b10; @(posedge clock); #1;
            reset = 1;   @(posedge clock); #1;
            reset = 0;   @(posedge clock); #1;

            #1;


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
        input expected_yout;
        begin
            if (expected_yout === (expected_yout ^ yout ^ expected_yout)) begin
                $display("PASS");
                $display("  Outputs: yout=%b",
                         yout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: yout=%b",
                         expected_yout);
                $display("  Got:      yout=%b",
                         yout);
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
        $dumpvars(0,ain, clock, reset, yout);
    end

endmodule
