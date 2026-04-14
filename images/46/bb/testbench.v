`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg d;
    reg wclk;
    reg we;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .d(d),
        .wclk(wclk),
        .we(we),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        wclk = 0;
        forever #5 wclk = ~wclk;
    end

        task reset_dut;

        begin
            a = 0;
            d = 0;
            we = 0;
            @(posedge wclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Write 1 to Address 0");
            reset_dut();
            a = 4'h0;
            d = 1'b1;
            we = 1'b1;
            @(posedge wclk);
            #2;
            we = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Overwrite Address 0 with 0");
            reset_dut();

            a = 4'h0; d = 1'b1; we = 1'b1;
            @(posedge wclk);
            #2;

            d = 1'b0;
            @(posedge wclk);
            #2;
            we = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write 1 to Address 15");
            reset_dut();
            a = 4'hF;
            d = 1'b1;
            we = 1'b1;
            @(posedge wclk);
            #2;
            we = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Verify Write Enable functionality");
            reset_dut();

            a = 4'h5; d = 1'b0; we = 1'b1;
            @(posedge wclk);
            #2;

            d = 1'b1; we = 1'b0;
            @(posedge wclk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Address Isolation Check");
            reset_dut();

            a = 4'h2; d = 1'b1; we = 1'b1;
            @(posedge wclk);
            #2;

            a = 4'h3; d = 1'b0; we = 1'b1;
            @(posedge wclk);
            #2;

            we = 1'b0;
            a = 4'h2;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Asynchronous Read Check");
            reset_dut();

            a = 4'hA; d = 1'b1; we = 1'b1;
            @(posedge wclk);
            #2;

            a = 4'hB; d = 1'b0; we = 1'b1;
            @(posedge wclk);
            #2;
            we = 1'b0;

            a = 4'hA;
            #1;
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
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
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
        $dumpvars(0,a, d, wclk, we, q);
    end

endmodule
