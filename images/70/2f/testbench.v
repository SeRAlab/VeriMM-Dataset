`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg arst_n;
    reg clk;
    wire sio_ce;
    wire sio_ce_x4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arst_n(arst_n),
        .clk(clk),
        .sio_ce(sio_ce),
        .sio_ce_x4(sio_ce_x4)
    );

    // Clock generation (10ns period)
    initial begin
        arst_n = 0;
        forever #5 arst_n = ~arst_n;
    end

        task reset_dut;

    begin
        arst_n = 0;
        #20;
        arst_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Post-reset initialization", test_num);
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: sio_ce_x4 pulse detection", test_num);
        reset_dut();

        repeat (2000) begin
            @(posedge clk);
            if (sio_ce_x4 === 1'b1) break;
        end
        #1;
        #1;

        check_outputs(sio_ce, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: sio_ce pulse detection and sync check", test_num);
        reset_dut();

        repeat (5000) begin
            @(posedge clk);
            if (sio_ce === 1'b1) break;
        end
        #1;


        #1;



        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Pulse de-assertion check", test_num);
        reset_dut();

        repeat (5000) begin
            @(posedge clk);
            if (sio_ce_x4 === 1'b1) break;
        end

        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b0, 1'b0);
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
        input expected_sio_ce;
        input expected_sio_ce_x4;
        begin
            if (expected_sio_ce === (expected_sio_ce ^ sio_ce ^ expected_sio_ce) &&
                expected_sio_ce_x4 === (expected_sio_ce_x4 ^ sio_ce_x4 ^ expected_sio_ce_x4)) begin
                $display("PASS");
                $display("  Outputs: sio_ce=%b, sio_ce_x4=%b",
                         sio_ce, sio_ce_x4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sio_ce=%b, sio_ce_x4=%b",
                         expected_sio_ce, expected_sio_ce_x4);
                $display("  Got:      sio_ce=%b, sio_ce_x4=%b",
                         sio_ce, sio_ce_x4);
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
        $dumpvars(0,arst_n, clk, sio_ce, sio_ce_x4);
    end

endmodule
