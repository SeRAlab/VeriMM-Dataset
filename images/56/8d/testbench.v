`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg GCLK;
    reg RES;
    reg din;
    wire cntmn;
    wire cntmn_ready;
    wire dout;
    wire sync;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .GCLK(GCLK),
        .RES(RES),
        .din(din),
        .cntmn(cntmn),
        .cntmn_ready(cntmn_ready),
        .dout(dout),
        .sync(sync)
    );

    // Clock generation (10ns period)
    initial begin
        GCLK = 0;
        forever #5 GCLK = ~GCLK;
    end

        task reset_dut;

        begin
            RES = 1;
            din = 0;
            @(posedge GCLK);
            #2 RES = 0;
            @(posedge GCLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Reset state check", test_num);
            reset_dut();


            #1;



            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Sampling High Signal", test_num);
            reset_dut();

            din = 1;


            repeat (10) @(posedge GCLK);

            #1 #1;
 check_outputs(0, 1, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Input Change Detection", test_num);
            reset_dut();


            repeat (5) @(posedge GCLK);


            din = 1;
            @(posedge GCLK);
            #1;



            #1;




            check_outputs(1, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Sampling Low Signal and Sync", test_num);
            reset_dut();


            din = 1;
            repeat (10) @(posedge GCLK);


            din = 0;
            repeat (10) @(posedge GCLK);

            #1 #1;
 check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Rapid Input Toggle", test_num);
            reset_dut();

            din = 1;
            @(posedge GCLK);
            din = 0;
            @(posedge GCLK);
            din = 1;

            repeat (10) @(posedge GCLK);


            #1 #1;
 check_outputs(0, 1, 1, 1);
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
        input expected_cntmn;
        input expected_cntmn_ready;
        input expected_dout;
        input expected_sync;
        begin
            if (expected_cntmn === (expected_cntmn ^ cntmn ^ expected_cntmn) &&
                expected_cntmn_ready === (expected_cntmn_ready ^ cntmn_ready ^ expected_cntmn_ready) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_sync === (expected_sync ^ sync ^ expected_sync)) begin
                $display("PASS");
                $display("  Outputs: cntmn=%b, cntmn_ready=%b, dout=%b, sync=%b",
                         cntmn, cntmn_ready, dout, sync);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cntmn=%b, cntmn_ready=%b, dout=%b, sync=%b",
                         expected_cntmn, expected_cntmn_ready, expected_dout, expected_sync);
                $display("  Got:      cntmn=%b, cntmn_ready=%b, dout=%b, sync=%b",
                         cntmn, cntmn_ready, dout, sync);
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
        $dumpvars(0,GCLK, RES, din, cntmn, cntmn_ready, dout, sync);
    end

endmodule
