`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    reg sel_b1;
    reg sel_b2;
    wire out_always;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .out_always(out_always)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            sel_b1 = 0;
            sel_b2 = 0;

            repeat (5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select 'b' (sel_b1=0, sel_b2=0)", test_num);
            reset_dut();
            a = 1;
            b = 0;
            sel_b1 = 0;
            sel_b2 = 0;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select 'a' via sel_b1=1", test_num);
            reset_dut();
            a = 1;
            b = 0;
            sel_b1 = 1;
            sel_b2 = 0;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select 'a' via sel_b2=1", test_num);
            reset_dut();
            a = 1;
            b = 0;
            sel_b1 = 0;
            sel_b2 = 1;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select 'a' (both sel high)", test_num);
            reset_dut();
            a = 1;
            b = 0;
            sel_b1 = 1;
            sel_b2 = 1;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data propagation for 'b'", test_num);
            reset_dut();
            a = 0;
            b = 1;
            sel_b1 = 0;
            sel_b2 = 0;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data propagation for 'a'", test_num);
            reset_dut();
            a = 0;
            b = 1;
            sel_b1 = 1;
            sel_b2 = 0;
            repeat (5) @(posedge clk);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pipeline synchronization check", test_num);
            reset_dut();
            a = 1;
            b = 0;
            sel_b1 = 1;
            sel_b2 = 0;



            @(posedge clk); #1;


            if (out_always !== 0) $display("  Note: Output transitioned early or state was not reset.");

            repeat (4) @(posedge clk);
            #1;

            check_outputs(1);
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
        input expected_out_always;
        begin
            if (expected_out_always === (expected_out_always ^ out_always ^ expected_out_always)) begin
                $display("PASS");
                $display("  Outputs: out_always=%b",
                         out_always);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_always=%b",
                         expected_out_always);
                $display("  Got:      out_always=%b",
                         out_always);
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
        $dumpvars(0,a, b, clk, sel_b1, sel_b2, out_always);
    end

endmodule
