`timescale 1ns/1ps

module revised_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg j;
    wire k;
    wire l;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    revised_module dut (
        .clock(clock),
        .j(j),
        .k(k),
        .l(l)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            force dut.k = 0;
            force dut.l = 0;
            j = 0;
            @(posedge clock);
            #1;
            release dut.k;
            release dut.l;
            $display("DUT Reset: k=0, l=0");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: One falling edge (k toggles 0->1)", test_num);
            reset_dut();
            j = 0;
            @(negedge clock);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: One full cycle (k toggles, then l follows)", test_num);
            reset_dut();
            j = 1;
            @(negedge clock);
            @(posedge clock);
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Two full cycles (Gray-like sequence 11 -> 01 -> 00)", test_num);
            reset_dut();

            @(negedge clock);
            @(posedge clock);

            @(negedge clock);
            @(posedge clock);
            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Three negedges with varying j (j should be ignored)", test_num);
            reset_dut();
            j = 1;
            @(negedge clock);
            @(posedge clock);
            j = 0;
            @(negedge clock);
            @(posedge clock);
            j = 1;
            @(negedge clock);
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Four negedges (Return to 0,0 state)", test_num);
            reset_dut();
            repeat(4) begin
                @(negedge clock);
                @(posedge clock);
            end
            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("revised_module Testbench");
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
        input expected_k;
        input expected_l;
        begin
            if (expected_k === (expected_k ^ k ^ expected_k) &&
                expected_l === (expected_l ^ l ^ expected_l)) begin
                $display("PASS");
                $display("  Outputs: k=%b, l=%b",
                         k, l);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: k=%b, l=%b",
                         expected_k, expected_l);
                $display("  Got:      k=%b, l=%b",
                         k, l);
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
        $dumpvars(0,clock, j, k, l);
    end

endmodule
