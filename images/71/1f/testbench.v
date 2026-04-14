`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CTRL;
    reg [3:0] D;
    reg LOAD;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CTRL(CTRL),
        .D(D),
        .LOAD(LOAD),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        CTRL = 1;
        LOAD = 0;
        D = 4'h0;
        @(posedge CLK);
        #1;
        CTRL = 0;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Clear Functionality", test_num);

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Load Functionality (D=4'hA)", test_num);
        D = 4'hA;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Basic Counting (3 cycles)", test_num);

        repeat(3) @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Priority Check (CTRL vs LOAD)", test_num);
        CTRL = 1;
        LOAD = 1;
        D = 4'hF;
        @(posedge CLK);
        #1;
        CTRL = 0;
        LOAD = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Counter Rollover (15 to 0)", test_num);
        D = 4'hF;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Load then Increment", test_num);
        D = 4'h5;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h6);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Counting to 10", test_num);
        repeat(10) @(posedge CLK);
        #1;
        #1;

        check_outputs(4'd10);
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, CTRL, D, LOAD, Q);
    end

endmodule
