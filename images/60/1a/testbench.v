`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_24M;
    reg nRESETP;
    wire CLK_12M;
    wire CLK_1MB;
    wire CLK_68KCLK;
    wire CLK_68KCLKB;
    wire CLK_6MB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_24M(CLK_24M),
        .nRESETP(nRESETP),
        .CLK_12M(CLK_12M),
        .CLK_1MB(CLK_1MB),
        .CLK_68KCLK(CLK_68KCLK),
        .CLK_68KCLKB(CLK_68KCLKB),
        .CLK_6MB(CLK_6MB)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_24M = 0;
        forever #5 CLK_24M = ~CLK_24M;
    end

        task reset_dut;

        begin
            nRESETP = 0;
            #20;
            nRESETP = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking Reset State", test_num);
            nRESETP = 0;
            #50;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking 12MHz and 6MHz division", test_num);
            reset_dut();




            #10;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking 1MHz division", test_num);
            reset_dut();

            #120;


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking 68kHz and inverted output", test_num);
            reset_dut();


            #1760;

            if (CLK_68KCLK == 1'b1 && CLK_68KCLKB == 1'b0)
                #1;

                check_outputs(CLK_12M, CLK_1MB, 1'b1, 1'b0, CLK_6MB);
            else
                #1;

                check_outputs(CLK_12M, CLK_1MB, 1'b1, 1'b0, CLK_6MB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking outputs after 5000ns", test_num);
            reset_dut();
            #5000;

            if (^CLK_12M !== 1'bx && ^CLK_1MB !== 1'bx && ^CLK_68KCLK !== 1'bx) begin
                pass_count = pass_count + 1;
                $display("PASS: Signals stable and defined.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Signals contain X or Z.");
            end
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
        input expected_CLK_12M;
        input expected_CLK_1MB;
        input expected_CLK_68KCLK;
        input expected_CLK_68KCLKB;
        input expected_CLK_6MB;
        begin
            if (expected_CLK_12M === (expected_CLK_12M ^ CLK_12M ^ expected_CLK_12M) &&
                expected_CLK_1MB === (expected_CLK_1MB ^ CLK_1MB ^ expected_CLK_1MB) &&
                expected_CLK_68KCLK === (expected_CLK_68KCLK ^ CLK_68KCLK ^ expected_CLK_68KCLK) &&
                expected_CLK_68KCLKB === (expected_CLK_68KCLKB ^ CLK_68KCLKB ^ expected_CLK_68KCLKB) &&
                expected_CLK_6MB === (expected_CLK_6MB ^ CLK_6MB ^ expected_CLK_6MB)) begin
                $display("PASS");
                $display("  Outputs: CLK_12M=%b, CLK_1MB=%b, CLK_68KCLK=%b, CLK_68KCLKB=%b, CLK_6MB=%b",
                         CLK_12M, CLK_1MB, CLK_68KCLK, CLK_68KCLKB, CLK_6MB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLK_12M=%b, CLK_1MB=%b, CLK_68KCLK=%b, CLK_68KCLKB=%b, CLK_6MB=%b",
                         expected_CLK_12M, expected_CLK_1MB, expected_CLK_68KCLK, expected_CLK_68KCLKB, expected_CLK_6MB);
                $display("  Got:      CLK_12M=%b, CLK_1MB=%b, CLK_68KCLK=%b, CLK_68KCLKB=%b, CLK_6MB=%b",
                         CLK_12M, CLK_1MB, CLK_68KCLK, CLK_68KCLKB, CLK_6MB);
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
        $dumpvars(0,CLK_24M, nRESETP, CLK_12M, CLK_1MB, CLK_68KCLK, CLK_68KCLKB, CLK_6MB);
    end

endmodule
