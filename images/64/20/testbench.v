`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN_write_0;
    reg EN_write_1;
    reg EN_write_2;
    reg write_0;
    reg write_1;
    reg write_2;
    wire read_0;
    wire read_1;
    wire read_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .EN_write_0(EN_write_0),
        .EN_write_1(EN_write_1),
        .EN_write_2(EN_write_2),
        .write_0(write_0),
        .write_1(write_1),
        .write_2(write_2),
        .read_0(read_0),
        .read_1(read_1),
        .read_2(read_2)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        EN_write_0 = 1; EN_write_1 = 1; EN_write_2 = 1;
        write_0 = 0; write_1 = 0; write_2 = 0;
        @(posedge CLK);
        #1;
        EN_write_0 = 0; EN_write_1 = 0; EN_write_2 = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Write and Read for Port 0", test_num);
        reset_dut();
        EN_write_0 = 1; write_0 = 1;
        @(posedge CLK);
        #1;
        EN_write_0 = 0;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Write and Read for Port 1", test_num);
        reset_dut();
        EN_write_1 = 1; write_1 = 1;
        @(posedge CLK);
        #1;
        EN_write_1 = 0;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic Write and Read for Port 2", test_num);
        reset_dut();
        EN_write_2 = 1; write_2 = 1;
        @(posedge CLK);
        #1;
        EN_write_2 = 0;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify EN_write prevents data update", test_num);
        reset_dut();

        EN_write_0 = 1; write_0 = 1;
        @(posedge CLK);
        #1;

        EN_write_0 = 0; write_0 = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Concurrent Writes to All Ports", test_num);
        reset_dut();
        EN_write_0 = 1; write_0 = 1;
        EN_write_1 = 1; write_1 = 0;
        EN_write_2 = 1; write_2 = 1;
        @(posedge CLK);
        #1;
        EN_write_0 = 0; EN_write_1 = 0; EN_write_2 = 0;
        #1;

        check_outputs(1, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Verify port independence and value update", test_num);
        reset_dut();

        EN_write_0 = 1; EN_write_1 = 1; EN_write_2 = 1;
        write_0 = 1; write_1 = 1; write_2 = 1;
        @(posedge CLK);
        #1;

        EN_write_0 = 0; EN_write_1 = 1; EN_write_2 = 0;
        write_0 = 1; write_1 = 0; write_2 = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(1, 0, 1);
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
        input expected_read_0;
        input expected_read_1;
        input expected_read_2;
        begin
            if (expected_read_0 === (expected_read_0 ^ read_0 ^ expected_read_0) &&
                expected_read_1 === (expected_read_1 ^ read_1 ^ expected_read_1) &&
                expected_read_2 === (expected_read_2 ^ read_2 ^ expected_read_2)) begin
                $display("PASS");
                $display("  Outputs: read_0=%b, read_1=%b, read_2=%b",
                         read_0, read_1, read_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_0=%b, read_1=%b, read_2=%b",
                         expected_read_0, expected_read_1, expected_read_2);
                $display("  Got:      read_0=%b, read_1=%b, read_2=%b",
                         read_0, read_1, read_2);
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
        $dumpvars(0,CLK, EN_write_0, EN_write_1, EN_write_2, write_0, write_1, write_2, read_0, read_1, read_2);
    end

endmodule
