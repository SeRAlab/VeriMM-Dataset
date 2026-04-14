`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ena;
    reg [3:0] in;
    reg [1:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ena(ena),
        .in(in),
        .sel(sel),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        ena = 0;
        forever #5 ena = ~ena;
    end

        task reset_dut;

        begin
            in = 4'b0000;
            sel = 2'b00;


            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Enable LOW check", test_num);
            force ena = 0;
            in = 4'b1111;
            sel = 2'b00;
            #5;
            #1;

            check_outputs(1'b0);
            release ena;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Select Input 0 (High)", test_num);
            force ena = 1;
            in = 4'b0001;
            sel = 2'b00;
            #5;
            #1;

            check_outputs(1'b1);
            release ena;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Select Input 1 (High)", test_num);
            force ena = 1;
            in = 4'b0010;
            sel = 2'b01;
            #5;
            #1;

            check_outputs(1'b1);
            release ena;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Select Input 2 (High)", test_num);
            force ena = 1;
            in = 4'b0100;
            sel = 2'b10;
            #5;
            #1;

            check_outputs(1'b1);
            release ena;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Select Input 3 (High)", test_num);
            force ena = 1;
            in = 4'b1000;
            sel = 2'b11;
            #5;
            #1;

            check_outputs(1'b1);
            release ena;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Select Input 1 (Low)", test_num);
            force ena = 1;
            in = 4'b1101;
            sel = 2'b01;
            #5;
            #1;

            check_outputs(1'b0);
            release ena;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Enable toggle check", test_num);
            in = 4'b1111;
            sel = 2'b10;


            force ena = 0;
            #5 #1;
 check_outputs(1'b0);


            force ena = 1;
            #5 #1;
 check_outputs(1'b1);
            release ena;
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
        $dumpvars(0,ena, in, sel, out);
    end

endmodule
