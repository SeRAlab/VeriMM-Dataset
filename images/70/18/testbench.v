`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [44:0] digits45;
    reg enable;
    wire [15:0] iddecimal4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .digits45(digits45),
        .enable(enable),
        .iddecimal4(iddecimal4)
    );

    // Clock generation (10ns period)
    initial begin
        enable = 0;
        forever #5 enable = ~enable;
    end

        task reset_dut;

    begin
        digits45 = 0;
        @(posedge enable);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 0", test_num);
        reset_dut();
        digits45 = 45'd0;
        @(posedge enable);
        #2;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 7", test_num);
        reset_dut();
        digits45 = 45'd7;
        @(posedge enable);
        #2;
        #1;

        check_outputs(16'h0007);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 1234", test_num);
        reset_dut();
        digits45 = 45'd1234;
        @(posedge enable);
        #2;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 9999", test_num);
        reset_dut();
        digits45 = 45'd9999;
        @(posedge enable);
        #2;
        #1;

        check_outputs(16'h9999);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 10000 (Wrap/Truncate)", test_num);
        reset_dut();
        digits45 = 45'd10000;
        @(posedge enable);
        #2;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 876543", test_num);
        reset_dut();
        digits45 = 45'd876543;
        @(posedge enable);
        #2;
        #1;

        check_outputs(16'h6543);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = Max 45-bit (2^45-1)", test_num);
        reset_dut();
        digits45 = 45'h1FFFFFFFFFFF;
        @(posedge enable);
        #2;
        #1;

        check_outputs(16'h8831);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input = 5050", test_num);
        reset_dut();
        digits45 = 45'd5050;
        @(posedge enable);
        #2;
        #1;

        check_outputs(16'h5050);
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
        input [15:0] expected_iddecimal4;
        begin
            if (expected_iddecimal4 === (expected_iddecimal4 ^ iddecimal4 ^ expected_iddecimal4)) begin
                $display("PASS");
                $display("  Outputs: iddecimal4=%h",
                         iddecimal4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: iddecimal4=%h",
                         expected_iddecimal4);
                $display("  Got:      iddecimal4=%h",
                         iddecimal4);
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
        $dumpvars(0,digits45, enable, iddecimal4);
    end

endmodule
