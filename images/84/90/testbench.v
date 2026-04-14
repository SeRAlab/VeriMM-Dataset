`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg sync;
    wire event_off;
    wire event_on;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sync(sync),
        .event_off(event_off),
        .event_on(event_on)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sync = 0;
            repeat(10) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Short High Glitch (Should not trigger event_on)", test_num);
            reset_dut();
            sync = 1;
            repeat(3) @(posedge clk);
            sync = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stable High Signal (Should trigger event_on)", test_num);
            reset_dut();
            sync = 1;



            repeat(31) @(posedge clk);
            #1;

            if (event_on === 1'b1) begin
                #1;

                check_outputs(1'b0, 1'b1);
            end else begin

                repeat(33) @(posedge clk);
                #1;
                #1;

                check_outputs(1'b0, 1'b1);
            end
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition to Low (Should trigger event_off)", test_num);
            reset_dut();
            sync = 1;
            repeat(64) @(posedge clk);
            sync = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Post-event_on Stability (Pulse should end)", test_num);
            reset_dut();
            sync = 1;
            repeat(64) @(posedge clk);
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Repeated Signal Detection", test_num);
            reset_dut();

            sync = 1; repeat(64) @(posedge clk);
            sync = 0; repeat(10) @(posedge clk);

            sync = 1;
            repeat(64) @(posedge clk);
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
        input expected_event_off;
        input expected_event_on;
        begin
            if (expected_event_off === (expected_event_off ^ event_off ^ expected_event_off) &&
                expected_event_on === (expected_event_on ^ event_on ^ expected_event_on)) begin
                $display("PASS");
                $display("  Outputs: event_off=%b, event_on=%b",
                         event_off, event_on);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: event_off=%b, event_on=%b",
                         expected_event_off, expected_event_on);
                $display("  Got:      event_off=%b, event_on=%b",
                         event_off, event_on);
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
        $dumpvars(0,clk, sync, event_off, event_on);
    end

endmodule
