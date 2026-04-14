`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg c;
    reg r;
    reg w;
    reg [7:0] wdata;
    wire ce;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .r(r),
        .w(w),
        .wdata(wdata),
        .ce(ce)
    );

    // Clock generation (10ns period)
    initial begin
        c = 0;
        forever #5 c = ~c;
    end

        task reset_dut;

        begin
            r = 1;
            w = 0;
            wdata = 0;
            @(posedge c);
            #1;
            r = 0;
            @(posedge c);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            w = 1; wdata = 8'd3;
            @(posedge c); #1;
            w = 0;
            repeat(3) @(posedge c);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            w = 1; wdata = 8'd3;
            @(posedge c); #1;
            w = 0;
            repeat(2) @(posedge c);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            w = 1; wdata = 8'd5;
            @(posedge c); #1;
            w = 0;
            repeat(5) @(posedge c);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            w = 1; wdata = 8'd1;
            @(posedge c); #1;
            w = 0;
            @(posedge c); #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            w = 1; wdata = 8'd10;
            @(posedge c); #1;
            w = 0;
            repeat(5) @(posedge c);
            r = 1;
            @(posedge c); #1;
            r = 0;
            #1;

            check_outputs(1'b0);
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
        input expected_ce;
        begin
            if (expected_ce === (expected_ce ^ ce ^ expected_ce)) begin
                $display("PASS");
                $display("  Outputs: ce=%b",
                         ce);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ce=%b",
                         expected_ce);
                $display("  Got:      ce=%b",
                         ce);
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
        $dumpvars(0,c, r, w, wdata, ce);
    end

endmodule
