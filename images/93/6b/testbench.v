`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ctl;
    reg vin;
    wire iout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctl(ctl),
        .vin(vin),
        .iout(iout)
    );

    // Clock generation (10ns period)
    initial begin
        ctl = 0;
        forever #5 ctl = ~ctl;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d...", test_num);
            vin = 0;

            repeat (20) @(posedge ctl);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            vin = 1;
            repeat (32) @(posedge ctl);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            vin = 0;
            repeat (32) @(posedge ctl);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge ctl);
            vin = 1;
            @(posedge ctl);
            vin = 0;
            repeat (10) @(posedge ctl);
            #2;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            repeat (5) @(posedge ctl) vin = 0;
            repeat (64) @(posedge ctl) vin = 1;
            #2;
            #1;

            check_outputs(1'b1);
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
        input expected_iout;
        begin
            if (expected_iout === (expected_iout ^ iout ^ expected_iout)) begin
                $display("PASS");
                $display("  Outputs: iout=%b",
                         iout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: iout=%b",
                         expected_iout);
                $display("  Got:      iout=%b",
                         iout);
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
        $dumpvars(0,ctl, vin, iout);
    end

endmodule
