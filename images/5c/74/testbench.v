`timescale 1ns/1ps

module door_lock_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg key;
    reg timeout;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    door_lock dut (
        .areset(areset),
        .clk(clk),
        .key(key),
        .timeout(timeout),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

    begin
        areset = 1;
        key = 0;
        timeout = 0;
        #15;
        areset = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Initial Reset to Locked", test_num);
        reset_dut();
        #1;

        check_outputs(LOCKED);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Locked to Unlocked (key=1)", test_num);
        reset_dut();
        @(posedge clk);
        key = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(UNLOCKED);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Unlocked to Waiting (key=0)", test_num);
        reset_dut();
        key = 1; @(posedge clk);
        #1;
        key = 0; @(posedge clk);
        #1;
        #1;

        check_outputs(WAITING);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Waiting to Locked (timeout=1)", test_num);
        reset_dut();
        key = 1; @(posedge clk);
        key = 0; @(posedge clk);
        #1;
        timeout = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(LOCKED);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Stay in Locked if no key", test_num);
        reset_dut();
        key = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(LOCKED);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Stay in Waiting if no timeout", test_num);
        reset_dut();
        key = 1; @(posedge clk);
        key = 0; @(posedge clk);
        timeout = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(WAITING);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Asynchronous reset from Unlocked state", test_num);
        reset_dut();
        key = 1; @(posedge clk);
        #1;
        areset = 1;
        #5;
        #1;

        check_outputs(LOCKED);
        areset = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("door_lock Testbench");
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
        input [1:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,areset, clk, key, timeout, state);
    end

endmodule
