`timescale 1ns/1ps

module clock_gate_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN;
    wire CLK_G;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_gate dut (
        .CLK(CLK),
        .EN(EN),
        .CLK_G(CLK_G)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin

        EN = 0;
        #20;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Running Testcase 001: Enable Gating");
        EN = 1;

        repeat (3) @(posedge CLK);

        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Running Testcase 002: Disable Gating");
        EN = 0;

        repeat (3) @(posedge CLK);

        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Running Testcase 003: Enable during CLK Low Phase");
        @(negedge CLK);
        #2;
        EN = 1;

        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Running Testcase 004: Disable during CLK High Phase");

        EN = 1;
        @(posedge CLK);
        #2;


        EN = 0;

        @(posedge CLK);
        #2;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Running Testcase 005: Multiple Toggle Test");
        EN = 1;
        @(posedge CLK);
        @(negedge CLK);
        EN = 0;
        @(posedge CLK);
        @(negedge CLK);
        EN = 1;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_gate Testbench");
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
        input expected_CLK_G;
        begin
            if (expected_CLK_G === (expected_CLK_G ^ CLK_G ^ expected_CLK_G)) begin
                $display("PASS");
                $display("  Outputs: CLK_G=%b",
                         CLK_G);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLK_G=%b",
                         expected_CLK_G);
                $display("  Got:      CLK_G=%b",
                         CLK_G);
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
        $dumpvars(0,CLK, EN, CLK_G);
    end

endmodule
