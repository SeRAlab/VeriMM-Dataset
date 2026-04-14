`timescale 1ns/1ps

module zero_crossing_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg signal_in;
    wire state;
    wire zero_cross;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zero_crossing_detector dut (
        .clk(clk),
        .rst(rst),
        .signal_in(signal_in),
        .state(state),
        .zero_cross(zero_cross)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        signal_in = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Initial Reset State", test_num);
        reset_dut();
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Positive Edge (0 -> 1)", test_num);
        reset_dut();
        @(posedge clk);
        signal_in = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Zero Cross Pulse Duration", test_num);
        reset_dut();
        @(posedge clk);
        signal_in = 1;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Negative Edge (1 -> 0)", test_num);
        reset_dut();

        @(posedge clk);
        signal_in = 1;
        repeat(2) @(posedge clk);

        signal_in = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Signal Stability", test_num);
        reset_dut();
        signal_in = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zero_crossing_detector Testbench");
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
        input expected_state;
        input expected_zero_cross;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state) &&
                expected_zero_cross === (expected_zero_cross ^ zero_cross ^ expected_zero_cross)) begin
                $display("PASS");
                $display("  Outputs: state=%b, zero_cross=%b",
                         state, zero_cross);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%b, zero_cross=%b",
                         expected_state, expected_zero_cross);
                $display("  Got:      state=%b, zero_cross=%b",
                         state, zero_cross);
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
        $dumpvars(0,clk, rst, signal_in, state, zero_cross);
    end

endmodule
