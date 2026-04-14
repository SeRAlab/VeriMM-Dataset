`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CSYSREQ;
    reg RST_N;
    wire CACTIVE;
    wire CSYSACK;
    wire req_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CSYSREQ(CSYSREQ),
        .RST_N(RST_N),
        .CACTIVE(CACTIVE),
        .CSYSACK(CSYSACK),
        .req_reg(req_reg)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST_N = 0;
        CSYSREQ = 1;
        #20;
        RST_N = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying reset state and HIGH request capture", test_num);
        reset_dut();

        @(posedge CLK);
        #2;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Verifying LOW request capture", test_num);
        reset_dut();
        CSYSREQ = 0;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Verifying transition from LOW to HIGH request", test_num);
        reset_dut();
        CSYSREQ = 0;
        @(posedge CLK);
        #2;
        CSYSREQ = 1;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verifying behavior over multiple toggle cycles", test_num);
        reset_dut();
        CSYSREQ = 0;
        @(posedge CLK);
        #2;
        CSYSREQ = 1;
        @(posedge CLK);
        #2;
        CSYSREQ = 0;
        @(posedge CLK);
        #2;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verifying CACTIVE stability", test_num);
        reset_dut();
        CSYSREQ = 1;
        repeat(5) @(posedge CLK);
        CSYSREQ = 0;
        repeat(2) @(posedge CLK);
        #2;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0);
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
        input expected_CACTIVE;
        input expected_CSYSACK;
        input expected_req_reg;
        begin
            if (expected_CACTIVE === (expected_CACTIVE ^ CACTIVE ^ expected_CACTIVE) &&
                expected_CSYSACK === (expected_CSYSACK ^ CSYSACK ^ expected_CSYSACK) &&
                expected_req_reg === (expected_req_reg ^ req_reg ^ expected_req_reg)) begin
                $display("PASS");
                $display("  Outputs: CACTIVE=%b, CSYSACK=%b, req_reg=%b",
                         CACTIVE, CSYSACK, req_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CACTIVE=%b, CSYSACK=%b, req_reg=%b",
                         expected_CACTIVE, expected_CSYSACK, expected_req_reg);
                $display("  Got:      CACTIVE=%b, CSYSACK=%b, req_reg=%b",
                         CACTIVE, CSYSACK, req_reg);
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
        $dumpvars(0,CLK, CSYSREQ, RST_N, CACTIVE, CSYSACK, req_reg);
    end

endmodule
