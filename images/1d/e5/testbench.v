`timescale 1ns/1ps

module nvme_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg done_signal;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_controller dut (
        .clk(clk),
        .done_signal(done_signal),
        .start(start),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin


        start = 0;
        done_signal = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Initial IDLE state", test_num);
        reset_dut();

        #1;


        check_outputs(IDLE);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Transition IDLE -> BUSY", test_num);
        reset_dut();

        start = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(BUSY);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Transition BUSY -> DONE", test_num);
        reset_dut();

        start = 1;
        @(posedge clk);
        start = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(DONE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Transition DONE -> IDLE", test_num);
        reset_dut();


        start = 1;
        @(posedge clk);
        start = 0;
        @(posedge clk);


        done_signal = 1;
        @(posedge clk);
        done_signal = 0;
        #1;
        #1;

        check_outputs(IDLE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Persistence in IDLE", test_num);
        reset_dut();

        start = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(IDLE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Persistence in DONE", test_num);
        reset_dut();


        start = 1;
        @(posedge clk);
        start = 0;
        @(posedge clk);


        done_signal = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(DONE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple Operation Cycles", test_num);
        reset_dut();


        start = 1; @(posedge clk); start = 0;
        @(posedge clk);
        done_signal = 1; @(posedge clk); done_signal = 0;


        start = 1; @(posedge clk); start = 0;
        @(posedge clk);
        done_signal = 1; @(posedge clk); done_signal = 0;

        #1;
        #1;

        check_outputs(IDLE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_controller Testbench");
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
        $dumpvars(0,clk, done_signal, start, state);
    end

endmodule
