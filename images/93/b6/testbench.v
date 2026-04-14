`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg dclkin;
    reg oe;
    reg scein;
    reg sdoin;
    wire data0out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dclkin(dclkin),
        .oe(oe),
        .scein(scein),
        .sdoin(sdoin),
        .data0out(data0out)
    );

    // Clock generation (10ns period)
    initial begin
        dclkin = 0;
        forever #5 dclkin = ~dclkin;
    end

        task reset_dut;

        begin
            scein = 0;
            oe = 0;
            sdoin = 0;
            @(posedge dclkin);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            scein = 1;
            oe = 0;
            sdoin = 1;
            @(posedge dclkin);
            #1;


            oe = 1;
            sdoin = 0;
            @(posedge dclkin);
            #1;

            $display("Testcase 001: Basic Write 1 and Read");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            scein = 1; oe = 0; sdoin = 1;
            @(posedge dclkin);
            #1;


            sdoin = 0;
            @(posedge dclkin);
            #1;


            oe = 1;
            @(posedge dclkin);
            #1;

            $display("Testcase 002: Basic Write 0 and Read");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            scein = 1; oe = 0; sdoin = 0;
            @(posedge dclkin);
            #1;


            scein = 0; oe = 0; sdoin = 1;
            @(posedge dclkin);
            #1;


            scein = 1; oe = 1;
            @(posedge dclkin);
            #1;

            $display("Testcase 003: scein Write Protection Check");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            scein = 1; oe = 0; sdoin = 0;
            @(posedge dclkin);
            #1;


            scein = 1; oe = 1; sdoin = 1;
            @(posedge dclkin);
            #1;


            oe = 1;
            @(posedge dclkin);
            #1;

            $display("Testcase 004: OE Priority Check (Read vs Write)");
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
        input expected_data0out;
        begin
            if (expected_data0out === (expected_data0out ^ data0out ^ expected_data0out)) begin
                $display("PASS");
                $display("  Outputs: data0out=%b",
                         data0out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data0out=%b",
                         expected_data0out);
                $display("  Got:      data0out=%b",
                         data0out);
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
        $dumpvars(0,dclkin, oe, scein, sdoin, data0out);
    end

endmodule
