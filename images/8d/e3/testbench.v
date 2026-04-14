`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLRN;
    reg D;
    reg ENA;
    reg PRN;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CLRN(CLRN),
        .D(D),
        .ENA(ENA),
        .PRN(PRN),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin

            CLRN = 1;
            PRN = 1;
            ENA = 0;
            D = 0;

            #2 CLRN = 0;
            #5 CLRN = 1;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Asynchronous Clear Assertion", test_num);
            reset_dut();

            PRN = 0;
            #5 PRN = 1;
            #2 CLRN = 0;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Asynchronous Preset Assertion", test_num);
            reset_dut();

            #2 PRN = 0;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Synchronous Load High (ENA=1, D=1)", test_num);
            reset_dut();
            ENA = 1;
            D = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Synchronous Load Low (ENA=1, D=0)", test_num);
            reset_dut();

            ENA = 1;
            D = 1;
            @(posedge CLK);

            @(negedge CLK);
            D = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Enable Disabled (ENA=0, maintaining state)", test_num);
            reset_dut();

            ENA = 1;
            D = 1;
            @(posedge CLK);
            #2;

            ENA = 0;
            D = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Async Clear Priority over Synchronous Load", test_num);
            reset_dut();
            ENA = 1;
            D = 1;
            CLRN = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Async Preset Priority over Synchronous Load", test_num);
            reset_dut();
            ENA = 1;
            D = 0;
            PRN = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Data toggling without Enable", test_num);
            reset_dut();
            ENA = 0;
            D = 1;
            @(posedge CLK);
            D = 0;
            @(posedge CLK);
            D = 1;
            @(posedge CLK);
            #2;
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
        $dumpvars(0,CLK, CLRN, D, ENA, PRN, Q);
    end

endmodule
