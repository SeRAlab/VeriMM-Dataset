`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg in;
    reg reset;
    reg [1:0] trim;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .reset(reset),
        .trim(trim),
        .out(out)
    );

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            trim = 2'b00;
            #200;
            reset = 0;
            #200;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset behavior check", test_num);
            reset_dut();
            in = 1;
            reset = 1;
            #500;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Trim 00 - Direct/Min Delay", test_num);
            reset_dut();
            trim = 2'b00;
            in = 1;
            #5000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Trim 01 - Short Delay", test_num);
            reset_dut();
            trim = 2'b01;
            in = 1;
            #20000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Trim 10 - Medium Delay", test_num);
            reset_dut();
            trim = 2'b10;
            in = 1;
            #40000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Trim 11 - Maximum Delay", test_num);
            reset_dut();
            trim = 2'b11;
            in = 1;
            #60000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Trim 00 - Input LOW propagation", test_num);
            reset_dut();
            trim = 2'b00;
            in = 1;
            #1000;
            in = 0;
            #5000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Trim 01 - Delayed LOW transition", test_num);
            reset_dut();
            trim = 2'b01;
            in = 1;
            #20000;
            in = 0;
            #5000;


            #20000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Trim transition check", test_num);
            reset_dut();
            in = 1;
            trim = 2'b11;
            #10000;
            trim = 2'b00;
            #5000;
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
        testcase008();
        
        
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
        $dumpvars(0,in, reset, trim, out);
    end

endmodule
