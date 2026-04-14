`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg se;
    reg si;
    wire q;
    wire so;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .se(se),
        .si(si),
        .q(q),
        .so(so)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            se = 0;
            din = 0;
            si = 0;
            @(negedge clk);


        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Normal Mode - Capture High", test_num);
            reset_dut();

            se = 0;
            din = 1;
            si = 0;
            @(negedge clk);

            #1;


            check_outputs(1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Normal Mode - Capture Low", test_num);
            reset_dut();


            se = 0;
            din = 1;
            @(negedge clk);


            din = 0;
            @(negedge clk);

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Scan Mode - Shift High", test_num);
            reset_dut();

            se = 1;
            si = 1;
            din = 0;
            @(negedge clk);

            #1;


            check_outputs(1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Scan Mode - Shift Low", test_num);
            reset_dut();


            se = 1;
            si = 1;
            @(negedge clk);


            si = 0;
            @(negedge clk);

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Priority Check (SE overrides DIN)", test_num);
            reset_dut();

            se = 1;
            si = 0;
            din = 1;
            @(negedge clk);


            #1;



            check_outputs(0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Normal mode ignores SI", test_num);
            reset_dut();

            se = 0;
            si = 1;
            din = 0;
            @(negedge clk);


            #1;



            check_outputs(0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Multi-cycle Scan Toggle", test_num);
            reset_dut();

            se = 1;
            si = 1; @(negedge clk);
            si = 0; @(negedge clk);
            si = 1; @(negedge clk);
            si = 1; @(negedge clk);
            si = 0; @(negedge clk);

            #1;


            check_outputs(0, 0);
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
        input expected_q;
        input expected_so;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_so === (expected_so ^ so ^ expected_so)) begin
                $display("PASS");
                $display("  Outputs: q=%b, so=%b",
                         q, so);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, so=%b",
                         expected_q, expected_so);
                $display("  Got:      q=%b, so=%b",
                         q, so);
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
        $dumpvars(0,clk, din, se, si, q, so);
    end

endmodule
