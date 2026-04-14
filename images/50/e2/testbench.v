`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rc_is_idle;
    reg rc_reqn;
    reg rstn;
    wire rc_ackn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rc_is_idle(rc_is_idle),
        .rc_reqn(rc_reqn),
        .rstn(rstn),
        .rc_ackn(rc_ackn)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            rc_is_idle = 0;
            rc_reqn = 1;
            @(posedge clk);
            #2 rstn = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Trigger Request", test_num);
            reset_dut();
            @(negedge clk);
            rc_reqn = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Complete Handshake", test_num);
            reset_dut();
            @(negedge clk);
            rc_reqn = 0;
            @(posedge clk);
            #2;
            @(negedge clk);
            rc_is_idle = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Persistent Ack until Idle", test_num);
            reset_dut();
            @(negedge clk);
            rc_reqn = 0;
            @(posedge clk);
            #2;
            @(negedge clk);
            rc_reqn = 1;
            rc_is_idle = 0;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Long duration request", test_num);
            reset_dut();
            @(negedge clk);
            rc_reqn = 0;
            repeat(5) @(posedge clk);
            @(negedge clk);
            rc_is_idle = 1;
            @(posedge clk);
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
        input expected_rc_ackn;
        begin
            if (expected_rc_ackn === (expected_rc_ackn ^ rc_ackn ^ expected_rc_ackn)) begin
                $display("PASS");
                $display("  Outputs: rc_ackn=%b",
                         rc_ackn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rc_ackn=%b",
                         expected_rc_ackn);
                $display("  Got:      rc_ackn=%b",
                         rc_ackn);
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
        $dumpvars(0,clk, rc_is_idle, rc_reqn, rstn, rc_ackn);
    end

endmodule
