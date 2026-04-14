`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EN;
    reg LD;
    reg SH;
    reg [15:0] in;
    reg [3:0] sel;
    wire [15:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .LD(LD),
        .SH(SH),
        .in(in),
        .sel(sel),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        EN = 0;
        forever #5 EN = ~EN;
    end

        task reset_dut;

        begin
            LD = 1;
            SH = 0;
            in = 16'h0000;
            sel = 4'h0;
            @(posedge EN);
            #1;
            LD = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            in = 16'hFFFF;
            LD = 1;
            SH = 0;
            @(posedge EN);
            #1;
            LD = 0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            in = 16'hAAAA;
            LD = 1;
            SH = 0;
            @(posedge EN);
            #1;
            LD = 0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            in = 16'h8001;
            LD = 1;
            @(posedge EN);
            #1;

            LD = 0;
            SH = 1;
            @(posedge EN);
            #1;
            SH = 0;

            #1;


            check_outputs(16'h4000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            in = 16'hF0F0;
            LD = 1;
            @(posedge EN);
            #1;
            LD = 0;
            SH = 1;
            @(posedge EN);
            @(posedge EN);
            #1;
            SH = 0;
            #1;

            check_outputs(16'h3C3C);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            in = 16'h1234;
            LD = 1;
            @(posedge EN);
            #1;
            LD = 0;
            SH = 0;
            @(posedge EN);
            @(posedge EN);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            in = 16'h0003;
            LD = 1;
            @(posedge EN);
            #1;
            LD = 0;
            SH = 1;
            @(posedge EN);
            @(posedge EN);
            @(posedge EN);
            #1;
            SH = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            in = 16'hABCD;
            LD = 1;
            SH = 1;
            @(posedge EN);
            #1;
            LD = 0;
            SH = 0;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            in = 16'h5555;
            sel = 4'hF;
            LD = 1;
            @(posedge EN);
            #1;
            LD = 0;
            #1;

            check_outputs(16'h5555);
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
        input [15:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,EN, LD, SH, in, sel, Q);
    end

endmodule
