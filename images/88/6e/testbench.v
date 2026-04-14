`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EXTCLK;
    reg EXTRSTn;
    reg clken;
    reg rsten;
    wire SYSCLK;
    wire SYSRSTn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXTCLK(EXTCLK),
        .EXTRSTn(EXTRSTn),
        .clken(clken),
        .rsten(rsten),
        .SYSCLK(SYSCLK),
        .SYSRSTn(SYSRSTn)
    );

    // Clock generation (10ns period)
    initial begin
        EXTCLK = 0;
        forever #5 EXTCLK = ~EXTCLK;
    end

        task reset_dut;

        begin
            EXTRSTn = 1;
            rsten   = 1;
            clken   = 0;
            @(posedge EXTCLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Assert External Reset", test_num);
            reset_dut();
            EXTRSTn = 0;
            rsten   = 1;
            #10;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: De-assert External Reset", test_num);
            reset_dut();
            EXTRSTn = 1;
            rsten   = 1;
            #10;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Clock (High Phase)", test_num);
            reset_dut();
            clken = 1;

            wait(EXTCLK == 1);
            #2;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable Clock (Low Phase)", test_num);
            reset_dut();
            clken = 1;

            wait(EXTCLK == 0);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Disable Clock", test_num);
            reset_dut();
            clken = 0;

            wait(EXTCLK == 1);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Disabled via rsten", test_num);
            reset_dut();
            rsten = 0;
            EXTRSTn = 0;
            #10;

            #1;


            check_outputs(1'b0, 1'b1);
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
        input expected_SYSCLK;
        input expected_SYSRSTn;
        begin
            if (expected_SYSCLK === (expected_SYSCLK ^ SYSCLK ^ expected_SYSCLK) &&
                expected_SYSRSTn === (expected_SYSRSTn ^ SYSRSTn ^ expected_SYSRSTn)) begin
                $display("PASS");
                $display("  Outputs: SYSCLK=%b, SYSRSTn=%b",
                         SYSCLK, SYSRSTn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SYSCLK=%b, SYSRSTn=%b",
                         expected_SYSCLK, expected_SYSRSTn);
                $display("  Got:      SYSCLK=%b, SYSRSTn=%b",
                         SYSCLK, SYSRSTn);
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
        $dumpvars(0,EXTCLK, EXTRSTn, clken, rsten, SYSCLK, SYSRSTn);
    end

endmodule
