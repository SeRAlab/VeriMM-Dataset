`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg c_in;
    reg clock;
    reg d_in;
    wire out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c_in(c_in),
        .clock(clock),
        .d_in(d_in),
        .out1(out1)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            c_in = 0;
            d_in = 0;


            c_in = 1; d_in = 0; @(posedge clock);

            c_in = 1; d_in = 0; @(posedge clock);

            c_in = 1; d_in = 0; @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: out1 stays 0 with all 0 inputs", test_num);
            reset_dut();
            c_in = 0; d_in = 0;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR 0 to 1 transition", test_num);
            reset_dut();
            c_in = 1; d_in = 0;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: OR 0 to 1 transition", test_num);
            reset_dut();
            c_in = 0; d_in = 1;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR toggle 1 back to 0", test_num);
            reset_dut();

            c_in = 1; d_in = 0;
            @(posedge clock); #1;

            c_in = 1; d_in = 0;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maintain state 1 with 0 inputs", test_num);
            reset_dut();

            c_in = 1; d_in = 0;
            @(posedge clock); #1;

            c_in = 0; d_in = 0;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Transition with both c_in and d_in high", test_num);
            reset_dut();

            c_in = 1; d_in = 1;
            @(posedge clock); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: OR overriding XOR toggle back to 0", test_num);
            reset_dut();

            c_in = 1; d_in = 0;
            @(posedge clock); #1;

            c_in = 1; d_in = 1;
            @(posedge clock); #1;
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
        input expected_out1;
        begin
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1)) begin
                $display("PASS");
                $display("  Outputs: out1=%b",
                         out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%b",
                         expected_out1);
                $display("  Got:      out1=%b",
                         out1);
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
        $dumpvars(0,c_in, clock, d_in, out1);
    end

endmodule
