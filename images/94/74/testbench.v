`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] d;
    reg en;
    reg rst_n;
    reg trig;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .en(en),
        .rst_n(rst_n),
        .trig(trig),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        rst_n = 0;
        forever #5 rst_n = ~rst_n;
    end

        task reset_dut;

        begin
            rst_n = 0;
            trig = 0;
            en = 0;
            d = 32'h0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Data Load (en=1)", test_num);
            reset_dut();
            d = 32'hACE1FACE;
            en = 1;
            #10;
            trig = 1;
            #10;
            trig = 0;
            #10;
            #1;

            check_outputs(32'hACE1FACE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Hold (en=0)", test_num);
            reset_dut();


            d = 32'h12345678;
            en = 1;
            #10; trig = 1; #10; trig = 0; #10;


            d = 32'h87654321;
            en = 0;
            #10; trig = 1; #10; trig = 0; #10;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Data Transitions", test_num);
            reset_dut();
            en = 1;

            d = 32'hAAAA_AAAA;
            #10; trig = 1; #10; trig = 0; #10;

            d = 32'h5555_5555;
            #10; trig = 1; #10; trig = 0; #10;

            d = 32'hDEAD_BEEF;
            #10; trig = 1; #10; trig = 0; #10;

            #1;


            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-operation Reset", test_num);
            reset_dut();


            d = 32'hFFFF_FFFF;
            en = 1;
            #10; trig = 1; #10; trig = 0; #10;


            rst_n = 0;
            #10;

            #1;


            check_outputs(32'h0);
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
        input [31:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,d, en, rst_n, trig, q);
    end

endmodule
