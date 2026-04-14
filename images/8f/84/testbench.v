`timescale 1ns/1ps

module reset_enable_sequential_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    wire u;
    wire v;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reset_enable_sequential_module dut (
        .clock(clock),
        .reset(reset),
        .u(u),
        .v(v)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 0;

            @(negedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            reset = 1;
            @(posedge clock);
            #1;


            #1;



            check_outputs(1'b0, v);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            repeat(2) begin
                reset = 1;
                @(posedge clock);
            end
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(3) begin
                reset = 1;
                @(posedge clock);
            end
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat(4) begin
                reset = 1;
                @(posedge clock);
            end
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat(5) begin
                reset = 1;
                @(posedge clock);
            end
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat(6) begin
                reset = 1;
                @(posedge clock);
            end
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
        $display("reset_enable_sequential_module Testbench");
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
        $dumpvars(0,clock, reset, u, v);
    end

endmodule
