`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] cnt;
    reg signalCapteur;
    wire [15:0] memo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cnt(cnt),
        .signalCapteur(signalCapteur),
        .memo(memo)
    );

        task reset_dut;

        begin
            signalCapteur = 1'b1;
            cnt = 16'h0000;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic Falling Edge Capture", test_num);
            reset_dut();

            cnt = 16'hABCD;
            #10;
            signalCapteur = 1'b0;
            #10;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Rising Edge Sensitivity Check", test_num);
            reset_dut();


            cnt = 16'h1111;
            #10;
            signalCapteur = 1'b0;
            #10;


            signalCapteur = 1'b1;
            cnt = 16'hEEEE;
            #10;


            #1;



            check_outputs(16'h1111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Data Retention (Steady Signal)", test_num);
            reset_dut();

            cnt = 16'h5555;
            #10;
            signalCapteur = 1'b0;
            #10;


            cnt = 16'hAAAA;
            #10;


            #1;



            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Successive Falling Edges", test_num);
            reset_dut();


            cnt = 16'h1234;
            #10;
            signalCapteur = 1'b0;
            #10;


            signalCapteur = 1'b1;
            cnt = 16'h8765;
            #10;
            signalCapteur = 1'b0;
            #10;

            #1;


            check_outputs(16'h8765);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Boundary Values (0000 and FFFF)", test_num);
            reset_dut();

            cnt = 16'hFFFF;
            #10;
            signalCapteur = 1'b0;
            #10;

            signalCapteur = 1'b1;
            cnt = 16'h0000;
            #10;
            signalCapteur = 1'b0;
            #10;

            #1;


            check_outputs(16'h0000);
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
        input [15:0] expected_memo;
        begin
            if (expected_memo === (expected_memo ^ memo ^ expected_memo)) begin
                $display("PASS");
                $display("  Outputs: memo=%h",
                         memo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memo=%h",
                         expected_memo);
                $display("  Got:      memo=%h",
                         memo);
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
        $dumpvars(0,cnt, signalCapteur, memo);
    end

endmodule
