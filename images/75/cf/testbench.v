`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RSTN;
    reg [15:0] d;
    reg [15:0] def;
    reg inc;
    reg load;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RSTN(RSTN),
        .d(d),
        .def(def),
        .inc(inc),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RSTN = 0;
            load = 0;
            inc = 0;
            d = 16'h0000;
            def = 16'h0000;
            repeat(2) @(posedge CLK);
            #1;
            RSTN = 1;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            def = 16'hABCD;
            reset_dut();

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            def = 16'h0000;
            reset_dut();
            d = 16'h1234;
            load = 1;
            @(posedge CLK);
            #1;
            load = 0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            def = 16'h0005;
            reset_dut();
            inc = 1;
            @(posedge CLK);
            #1;
            inc = 0;
            #1;

            check_outputs(16'h0006);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            def = 16'h0010;
            reset_dut();
            inc = 1;
            repeat(3) @(posedge CLK);
            #1;
            inc = 0;
            #1;

            check_outputs(16'h0013);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            def = 16'h0000;
            reset_dut();
            d = 16'h5555;
            load = 1;
            inc = 1;
            @(posedge CLK);
            #1;
            load = 0;
            inc = 0;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            def = 16'h0000;
            reset_dut();
            d = 16'hFFFF;
            load = 1;
            @(posedge CLK);
            #1;
            load = 0;
            inc = 1;
            @(posedge CLK);
            #1;
            inc = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            def = 16'h7777;
            reset_dut();
            load = 0;
            inc = 0;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(16'h7777);
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
        input [15:0] expected_q;
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
        $dumpvars(0,CLK, RSTN, d, def, inc, load, q);
    end

endmodule
