`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ld;
    reg [15:0] what_on_bus;
    wire [15:0] storage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ld(ld),
        .what_on_bus(what_on_bus),
        .storage(storage)
    );

    // Clock generation (10ns period)
    initial begin
        ld = 0;
        forever #5 ld = ~ld;
    end

        task reset_dut;

        begin
            what_on_bus = 0;

            @(negedge ld);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Loading 0xAAAA");
            reset_dut();
            what_on_bus = 16'hAAAA;
            @(posedge ld);
            #2;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Loading 0x5555");
            reset_dut();
            what_on_bus = 16'h5555;
            @(posedge ld);
            #2;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verifying data persistence (no edge)");
            reset_dut();

            what_on_bus = 16'h1234;
            @(posedge ld);
            #2;

            what_on_bus = 16'hFFFF;
            #1;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Loading 0xFFFF");
            reset_dut();
            what_on_bus = 16'hFFFF;
            @(posedge ld);
            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Loading 0x0000");
            reset_dut();
            what_on_bus = 16'h0000;
            @(posedge ld);
            #2;
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
        input [15:0] expected_storage;
        begin
            if (expected_storage === (expected_storage ^ storage ^ expected_storage)) begin
                $display("PASS");
                $display("  Outputs: storage=%h",
                         storage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: storage=%h",
                         expected_storage);
                $display("  Got:      storage=%h",
                         storage);
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
        $dumpvars(0,ld, what_on_bus, storage);
    end

endmodule
