`timescale 1ns/1ps

module reg24_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [23:0] d;
    wire [23:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg24 dut (
        .clear(clear),
        .clk(clk),
        .d(d),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clear = 0;
        forever #5 clear = ~clear;
    end

        task reset_dut;

    begin
        clear = 1;
        d = 24'h0;
        #15;
        clear = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Reset Verification");
        reset_dut();
        #1;

        check_outputs(24'h000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Load 0xAAAAAA");
        reset_dut();
        d = 24'hAAAAAA;
        @(posedge clk);
        #2;
        #1;

        check_outputs(24'hAAAAAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Load 0x555555");
        reset_dut();
        d = 24'h555555;
        @(posedge clk);
        #2;
        #1;

        check_outputs(24'h555555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Load 0xFFFFFF");
        reset_dut();
        d = 24'hFFFFFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(24'hFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Asynchronous Clear Test");
        reset_dut();
        d = 24'h123456;
        @(posedge clk);
        #2;

        clear = 1;
        #1;
        #1;

        check_outputs(24'h000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg24 Testbench");
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
        input [23:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clear, clk, d, q);
    end

endmodule
