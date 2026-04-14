`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RS232_Rx;
    reg clk;
    reg resetn;
    wire P2;
    wire Pulse;
    wire RS232_Tx;
    wire Sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RS232_Rx(RS232_Rx),
        .clk(clk),
        .resetn(resetn),
        .P2(P2),
        .Pulse(Pulse),
        .RS232_Tx(RS232_Tx),
        .Sync(Sync)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            RS232_Rx = 1;
            #20;
            @(posedge clk);
            #2 resetn = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Post-Reset Initialization", test_num);
            reset_dut();

            #2 #1;
 check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: RS232 Relay Logic (Rx=0)", test_num);
            reset_dut();
            RS232_Rx = 0;

            @(posedge clk);
            #2 #1;
 check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: RS232 Relay Logic (Rx=1)", test_num);
            reset_dut();
            RS232_Rx = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Sync Pulse check (1000 cycles)", test_num);
            reset_dut();

            repeat(1000) @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Pulse and Sync check (2000 cycles)", test_num);
            reset_dut();

            repeat(2000) @(posedge clk);
            #2;

            #1;


            check_outputs(0, 1, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: P2 and Sync check (3000 cycles)", test_num);
            reset_dut();

            repeat(3000) @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Triple pulse alignment (6000 cycles)", test_num);
            reset_dut();

            repeat(6000) @(posedge clk);
            #2;

            #1;


            check_outputs(1, 1, 1, 1);
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
        input expected_P2;
        input expected_Pulse;
        input expected_RS232_Tx;
        input expected_Sync;
        begin
            if (expected_P2 === (expected_P2 ^ P2 ^ expected_P2) &&
                expected_Pulse === (expected_Pulse ^ Pulse ^ expected_Pulse) &&
                expected_RS232_Tx === (expected_RS232_Tx ^ RS232_Tx ^ expected_RS232_Tx) &&
                expected_Sync === (expected_Sync ^ Sync ^ expected_Sync)) begin
                $display("PASS");
                $display("  Outputs: P2=%b, Pulse=%b, RS232_Tx=%b, Sync=%b",
                         P2, Pulse, RS232_Tx, Sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P2=%b, Pulse=%b, RS232_Tx=%b, Sync=%b",
                         expected_P2, expected_Pulse, expected_RS232_Tx, expected_Sync);
                $display("  Got:      P2=%b, Pulse=%b, RS232_Tx=%b, Sync=%b",
                         P2, Pulse, RS232_Tx, Sync);
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
        $dumpvars(0,RS232_Rx, clk, resetn, P2, Pulse, RS232_Tx, Sync);
    end

endmodule
