`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg UDP_IN;
    reg VPWR;
    wire UDP_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .UDP_IN(UDP_IN),
        .VPWR(VPWR),
        .UDP_OUT(UDP_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            UDP_IN = 0;
            VPWR = 0;

            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: VPWR=1, UDP_IN=0 -> Expected UDP_OUT=1");
            VPWR = 1;
            UDP_IN = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: VPWR=1, UDP_IN=1 -> Expected UDP_OUT=0");
            VPWR = 1;
            UDP_IN = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: VPWR=0, UDP_IN=0 -> Expected UDP_OUT=0");
            VPWR = 0;
            UDP_IN = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: VPWR=0, UDP_IN=1 -> Expected UDP_OUT=0");
            VPWR = 0;
            UDP_IN = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Input changes mid-cycle should not affect output until next edge");
            VPWR = 1;
            UDP_IN = 0;
            @(posedge CLK);
            #2;
            VPWR = 0;
            UDP_IN = 1;
            #1;

            if (UDP_OUT === 1'b1) begin
                @(posedge CLK);
                #2;
                #1;

                check_outputs(1'b0);
            end else begin
                $display("FAIL: Output changed asynchronously");
                fail_count = fail_count + 1;
            end
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
        input expected_UDP_OUT;
        begin
            if (expected_UDP_OUT === (expected_UDP_OUT ^ UDP_OUT ^ expected_UDP_OUT)) begin
                $display("PASS");
                $display("  Outputs: UDP_OUT=%b",
                         UDP_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: UDP_OUT=%b",
                         expected_UDP_OUT);
                $display("  Got:      UDP_OUT=%b",
                         UDP_OUT);
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
        $dumpvars(0,CLK, UDP_IN, VPWR, UDP_OUT);
    end

endmodule
