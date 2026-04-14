`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLK;
    reg iReset_n;
    wire oCLOCK_30;
    wire oCLOCK_b;
    wire oCLOCK_wd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLK(iCLK),
        .iReset_n(iReset_n),
        .oCLOCK_30(oCLOCK_30),
        .oCLOCK_b(oCLOCK_b),
        .oCLOCK_wd(oCLOCK_wd)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

        begin
            iReset_n = 0;
            repeat(2) @(posedge iCLK);
            #1;
            iReset_n = 1;
            @(posedge iCLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: LSB Toggling (Bit 0)", test_num);
            reset_dut();



            #1;




            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: 10th Bit Toggling (Index 9)", test_num);
            reset_dut();
            repeat(511) @(posedge iCLK);
            #1;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: 14th Bit Toggling (Index 13)", test_num);
            reset_dut();
            repeat(8191) @(posedge iCLK);
            #1;


            #1;



            check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Asynchronous Reset Mid-Operation", test_num);
            reset_dut();
            repeat(100) @(posedge iCLK);
            iReset_n = 0;
            #1;
            #1;

            check_outputs(0, 0, 0);
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
        input expected_oCLOCK_30;
        input expected_oCLOCK_b;
        input expected_oCLOCK_wd;
        begin
            if (expected_oCLOCK_30 === (expected_oCLOCK_30 ^ oCLOCK_30 ^ expected_oCLOCK_30) &&
                expected_oCLOCK_b === (expected_oCLOCK_b ^ oCLOCK_b ^ expected_oCLOCK_b) &&
                expected_oCLOCK_wd === (expected_oCLOCK_wd ^ oCLOCK_wd ^ expected_oCLOCK_wd)) begin
                $display("PASS");
                $display("  Outputs: oCLOCK_30=%b, oCLOCK_b=%b, oCLOCK_wd=%b",
                         oCLOCK_30, oCLOCK_b, oCLOCK_wd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oCLOCK_30=%b, oCLOCK_b=%b, oCLOCK_wd=%b",
                         expected_oCLOCK_30, expected_oCLOCK_b, expected_oCLOCK_wd);
                $display("  Got:      oCLOCK_30=%b, oCLOCK_b=%b, oCLOCK_wd=%b",
                         oCLOCK_30, oCLOCK_b, oCLOCK_wd);
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
        $dumpvars(0,iCLK, iReset_n, oCLOCK_30, oCLOCK_b, oCLOCK_wd);
    end

endmodule
