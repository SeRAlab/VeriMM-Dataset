`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg sync_rot_a;
    reg sync_rot_b;
    wire event_rot_l;
    wire event_rot_r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sync_rot_a(sync_rot_a),
        .sync_rot_b(sync_rot_b),
        .event_rot_l(event_rot_l),
        .event_rot_r(event_rot_r)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sync_rot_a = 1'b1;
            sync_rot_b = 1'b1;
            repeat(3) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            $display("Testcase %03d: Checking idle state stability", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            sync_rot_a = 1'b0;
            sync_rot_b = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %03d: CW Transition 11 -> 01", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            sync_rot_a = 1'b1;
            sync_rot_b = 1'b0;
            @(posedge clk);
            #1;
            $display("Testcase %03d: CCW Transition 11 -> 10", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            sync_rot_a = 1'b0; sync_rot_b = 1'b1; @(posedge clk);
            sync_rot_a = 1'b0; sync_rot_b = 1'b0; @(posedge clk);
            #1;
            $display("Testcase %03d: CW Transition 01 -> 00", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            sync_rot_a = 1'b1; sync_rot_b = 1'b0; @(posedge clk);
            sync_rot_a = 1'b0; sync_rot_b = 1'b0; @(posedge clk);
            #1;
            $display("Testcase %03d: CCW Transition 10 -> 00", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            sync_rot_a = 1'b0; sync_rot_b = 1'b1; @(posedge clk);
            sync_rot_a = 1'b1; sync_rot_b = 1'b1; @(posedge clk);
            #1;
            $display("Testcase %03d: Glitch recovery 11 -> 01 -> 11", test_num);
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
        input expected_event_rot_l;
        input expected_event_rot_r;
        begin
            if (expected_event_rot_l === (expected_event_rot_l ^ event_rot_l ^ expected_event_rot_l) &&
                expected_event_rot_r === (expected_event_rot_r ^ event_rot_r ^ expected_event_rot_r)) begin
                $display("PASS");
                $display("  Outputs: event_rot_l=%b, event_rot_r=%b",
                         event_rot_l, event_rot_r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: event_rot_l=%b, event_rot_r=%b",
                         expected_event_rot_l, expected_event_rot_r);
                $display("  Got:      event_rot_l=%b, event_rot_r=%b",
                         event_rot_l, event_rot_r);
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
        $dumpvars(0,clk, sync_rot_a, sync_rot_b, event_rot_l, event_rot_r);
    end

endmodule
