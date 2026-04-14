`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_2MHZ;
    reg CLK_SEL;
    reg CLK_SLOW;
    reg FCLK;
    reg MCLK;
    reg NPURST;
    wire CLK1;
    wire CLK2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_2MHZ(CLK_2MHZ),
        .CLK_SEL(CLK_SEL),
        .CLK_SLOW(CLK_SLOW),
        .FCLK(FCLK),
        .MCLK(MCLK),
        .NPURST(NPURST),
        .CLK1(CLK1),
        .CLK2(CLK2)
    );

    // Clock generation (10ns period)
    initial begin
        NPURST = 0;
        forever #5 NPURST = ~NPURST;
    end

        task reset_dut;

        begin
            CLK_2MHZ = 0;
            CLK_SEL = 0;
            CLK_SLOW = 0;
            FCLK = 0;
            MCLK = 0;

            wait(NPURST == 0);
            #10;
            wait(NPURST == 1);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset State Check", test_num);
            reset_dut();
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: CLK_SEL=0 Selection (MCLK/SLOW)", test_num);
            reset_dut();
            CLK_SEL = 0;
            MCLK = 1;
            CLK_SLOW = 1;
            FCLK = 0;
            CLK_2MHZ = 0;

            repeat(2) @(posedge NPURST);
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: CLK_SEL=1 Selection (FCLK/2MHZ)", test_num);
            reset_dut();
            CLK_SEL = 1;
            MCLK = 0;
            CLK_SLOW = 0;
            FCLK = 1;
            CLK_2MHZ = 1;
            repeat(2) @(posedge NPURST);
            #2;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Isolation Check (SEL=0, Toggle Unselected)", test_num);
            reset_dut();
            CLK_SEL = 0;
            MCLK = 0;
            CLK_SLOW = 0;
            FCLK = 1;
            CLK_2MHZ = 1;
            repeat(2) @(posedge NPURST);
            #2;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Isolation Check (SEL=1, Toggle Unselected)", test_num);
            reset_dut();
            CLK_SEL = 1;
            MCLK = 1;
            CLK_SLOW = 1;
            FCLK = 0;
            CLK_2MHZ = 0;
            repeat(2) @(posedge NPURST);
            #2;
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
        input expected_CLK1;
        input expected_CLK2;
        begin
            if (expected_CLK1 === (expected_CLK1 ^ CLK1 ^ expected_CLK1) &&
                expected_CLK2 === (expected_CLK2 ^ CLK2 ^ expected_CLK2)) begin
                $display("PASS");
                $display("  Outputs: CLK1=%b, CLK2=%b",
                         CLK1, CLK2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLK1=%b, CLK2=%b",
                         expected_CLK1, expected_CLK2);
                $display("  Got:      CLK1=%b, CLK2=%b",
                         CLK1, CLK2);
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
        $dumpvars(0,CLK_2MHZ, CLK_SEL, CLK_SLOW, FCLK, MCLK, NPURST, CLK1, CLK2);
    end

endmodule
