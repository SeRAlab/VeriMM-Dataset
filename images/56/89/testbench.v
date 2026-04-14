`timescale 1ns/1ps

module counter_down_5bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN;
    reg RST;
    wire [4:0] COUNT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_down_5bit dut (
        .CLK(CLK),
        .EN(EN),
        .RST(RST),
        .COUNT(COUNT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        EN = 0;
        @(posedge CLK);
        #1;
        RST = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Value Check", test_num);
        reset_dut();

        #1;


        check_outputs(5'd31);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Decrement (5 cycles)", test_num);
        reset_dut();
        EN = 1;

        repeat(5) @(posedge CLK);
        #1;
        #1;

        check_outputs(5'd26);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Enable Signal Gating Check", test_num);
        reset_dut();
        EN = 0;
        repeat(10) @(posedge CLK);
        #1;

        #1;


        check_outputs(5'd31);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Wrap-around Check (31 to 0 to 31)", test_num);
        reset_dut();
        EN = 1;

        repeat(31) @(posedge CLK);

        @(posedge CLK);
        #1;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Synchronous Reset During Counting", test_num);
        reset_dut();
        EN = 1;
        repeat(10) @(posedge CLK);
        RST = 1;
        @(posedge CLK);
        #1;
        RST = 0;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Intermittent Enable Check", test_num);
        reset_dut();
        EN = 1;
        repeat(5) @(posedge CLK);
        EN = 0;
        repeat(5) @(posedge CLK);
        EN = 1;
        repeat(2) @(posedge CLK);
        #1;
        #1;

        check_outputs(5'd24);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_down_5bit Testbench");
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
        input [4:0] expected_COUNT;
        begin
            if (expected_COUNT === (expected_COUNT ^ COUNT ^ expected_COUNT)) begin
                $display("PASS");
                $display("  Outputs: COUNT=%h",
                         COUNT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUNT=%h",
                         expected_COUNT);
                $display("  Got:      COUNT=%h",
                         COUNT);
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
        $dumpvars(0,CLK, EN, RST, COUNT);
    end

endmodule
