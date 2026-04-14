`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg e;
    wire u;
    wire v;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .e(e),
        .u(u),
        .v(v)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        integer i;
        begin
            e = 1;
            for (i = 0; i < 4; i = i + 1) begin

                if (u === 1'b0 && v === 1'b1) begin
                    i = 4;
                end else begin
                    @(negedge clock);
                end
            end
            e = 0;
            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition (0,1) -> (1,1) with e=1", test_num);
            reset_dut();
            e = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
            e = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition (0,1) -> (1,1) -> (1,0) with e=1", test_num);
            reset_dut();
            e = 1;
            repeat(2) @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
            e = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Cycle (0,1) -> (0,1) with e=1", test_num);
            reset_dut();
            e = 1;
            repeat(3) @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
            e = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Logic - Hold state when e=0", test_num);
            reset_dut();
            e = 0;
            repeat(2) @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle e (0,1 -> 1,1 -> hold -> 1,0)", test_num);
            reset_dut();
            e = 1;
            @(posedge clock);
            e = 0;
            @(posedge clock);
            #1;
            e = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
            e = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple cycles with hold", test_num);
            reset_dut();
            e = 1;
            repeat(4) @(posedge clock);
            e = 0;
            repeat(3) @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_u;
        input expected_v;
        begin
            if (expected_u === (expected_u ^ u ^ expected_u) &&
                expected_v === (expected_v ^ v ^ expected_v)) begin
                $display("PASS");
                $display("  Outputs: u=%b, v=%b",
                         u, v);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: u=%b, v=%b",
                         expected_u, expected_v);
                $display("  Got:      u=%b, v=%b",
                         u, v);
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
        $dumpvars(0,clock, e, u, v);
    end

endmodule
