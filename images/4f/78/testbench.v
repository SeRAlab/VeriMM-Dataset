`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rot_a;
    reg rot_b;
    wire rot_dir;
    wire rot_event;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rot_a(rot_a),
        .rot_b(rot_b),
        .rot_dir(rot_dir),
        .rot_event(rot_event)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rot_a = 0;
            rot_b = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CW Direction Bit Check", test_num);
            reset_dut();
            rot_a = 0;
            rot_b = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: CCW Direction Bit Check", test_num);
            reset_dut();
            rot_a = 1;
            rot_b = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Event Trigger Check", test_num);
            reset_dut();
            rot_a = 1;
            rot_b = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(rot_dir, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle State Check", test_num);
            reset_dut();
            rot_a = 0;
            rot_b = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(rot_dir, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full CW Sequence (0,0 -> 0,1 -> 1,1)", test_num);
            reset_dut();
            rot_a = 0; rot_b = 1; @(posedge clk);
            rot_a = 1; rot_b = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full CCW Sequence (0,0 -> 1,0 -> 1,1)", test_num);
            reset_dut();
            rot_a = 1; rot_b = 0; @(posedge clk);
            rot_a = 1; rot_b = 1; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_rot_dir;
        input expected_rot_event;
        begin
            if (expected_rot_dir === (expected_rot_dir ^ rot_dir ^ expected_rot_dir) &&
                expected_rot_event === (expected_rot_event ^ rot_event ^ expected_rot_event)) begin
                $display("PASS");
                $display("  Outputs: rot_dir=%b, rot_event=%b",
                         rot_dir, rot_event);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rot_dir=%b, rot_event=%b",
                         expected_rot_dir, expected_rot_event);
                $display("  Got:      rot_dir=%b, rot_event=%b",
                         rot_dir, rot_event);
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
        $dumpvars(0,clk, rot_a, rot_b, rot_dir, rot_event);
    end

endmodule
