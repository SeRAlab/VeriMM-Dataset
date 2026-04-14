`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] tone;
    wire [31:0] freq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .tone(tone),
        .freq(freq)
    );
    task testcase001;

    begin
        test_num = 1;
        tone = 16'h0000;
        #1;

        check_outputs(DEFAULT_FREQ);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        tone = 16'h0001;
        #1;

        check_outputs(FREQ_BIT0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        tone = 16'h0002;
        #1;

        check_outputs(FREQ_BIT1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        tone = 16'h0010;
        #1;

        check_outputs(FREQ_BIT4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        tone = 16'h0080;
        #1;

        check_outputs(FREQ_BIT7);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        tone = 16'h0800;
        #1;

        check_outputs(FREQ_BIT11);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        tone = 16'h1000;
        #1;

        check_outputs(FREQ_BIT12);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        tone = 16'h8000;
        #1;

        check_outputs(FREQ_BIT15);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        tone = 16'h0003;
        #1;

        check_outputs(FREQ_BIT0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        tone = 16'h9000;
        #1;

        check_outputs(FREQ_BIT12);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        tone = 16'hFFFF;
        #1;

        check_outputs(FREQ_BIT0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        tone = 16'h0020;
        #1;

        check_outputs(FREQ_BIT5);
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [31:0] expected_freq;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_freq === (expected_freq ^ freq ^ expected_freq)) begin
                $display("PASS");
                $display("  Outputs: freq=%h",
                         freq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: freq=%h",
                         expected_freq);
                $display("  Got:      freq=%h",
                         freq);
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

endmodule
