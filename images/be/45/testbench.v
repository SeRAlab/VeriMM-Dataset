`timescale 1ns/1ps

module bin_counter_4bit_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN;
    reg RST;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin_counter_4bit dut (
        .CLK(CLK),
        .EN(EN),
        .RST(RST),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        @(negedge CLK);
        RST = 1;
        EN = 0;
        @(negedge CLK);
        RST = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Basic Reset and Single Increment", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        @(negedge CLK);
        EN = 0;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Count to 5", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        repeat(5) @(negedge CLK);
        EN = 0;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Pause Counter using EN", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        repeat(3) @(negedge CLK);
        EN = 0;
        repeat(2) @(negedge CLK);
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Counter Wrap-around (17 cycles)", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        repeat(17) @(negedge CLK);
        EN = 0;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Priority Over Enable", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        repeat(4) @(negedge CLK);
        RST = 1;
        @(negedge CLK);
        RST = 0;
        EN = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Count to Max (15)", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        repeat(15) @(negedge CLK);
        EN = 0;
        #1;

        check_outputs(4'hF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin_counter_4bit Testbench");
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
        $dumpvars(0,CLK, EN, RST, Q);
    end

endmodule
