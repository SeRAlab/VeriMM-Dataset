`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ADn;
    reg ALn;
    reg CLK;
    reg D;
    reg EN;
    reg LAT;
    reg SD;
    reg SLn;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADn(ADn),
        .ALn(ALn),
        .CLK(CLK),
        .D(D),
        .EN(EN),
        .LAT(LAT),
        .SD(SD),
        .SLn(SLn),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        ALn = 0;
        forever #5 ALn = ~ALn;
    end

        task reset_dut;

        begin

            ALn = 1;
            SLn = 1;
            EN  = 1;
            LAT = 0;
            D   = 0;
            SD  = 0;
            ADn = 0;
            #10;

            ALn = 0;
            ADn = 0;
            #10;
            ALn = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Asynchronous Set", test_num);
            ALn = 0;
            ADn = 1;
            #5;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin

            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Asynchronous Reset", test_num);
            ALn = 0; ADn = 1; #5;

            ALn = 0; ADn = 0;
            #5;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Synchronous Load D=1", test_num);
            @(posedge CLK);
            EN = 1;
            SLn = 1;
            D = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Synchronous Load SD=1", test_num);
            @(posedge CLK);
            EN = 1;
            SLn = 0;
            SD = 1;
            D = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Clock Enable (EN=0)", test_num);

            @(posedge CLK);
            EN = 1; D = 1; SLn = 1;
            @(posedge CLK);
            #1;

            EN = 0;
            D = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: SLn priority over D", test_num);
            @(posedge CLK);
            EN = 1;
            SLn = 0;
            SD = 0;
            D = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Latch Mode (LAT=1)", test_num);
            LAT = 1;
            EN = 1;
            SLn = 1;

            force CLK = 1;
            D = 1;
            #5;
            #1;

            check_outputs(1);
            release CLK;
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: Async ALn Overrides Sync Clock", test_num);
            ALn = 0; ADn = 1;
            @(posedge CLK);
            EN = 1; SLn = 1; D = 0;
            @(posedge CLK);
            #1;
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
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
        $dumpvars(0,ADn, ALn, CLK, D, EN, LAT, SD, SLn, Q);
    end

endmodule
