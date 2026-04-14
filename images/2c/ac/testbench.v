`timescale 1ns/1ps

module bluetooth_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connection_fail;
    reg connection_success;
    reg rst;
    reg start_connect;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_fsm dut (
        .clk(clk),
        .connection_fail(connection_fail),
        .connection_success(connection_success),
        .rst(rst),
        .start_connect(start_connect),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start_connect = 0;
            connection_success = 0;
            connection_fail = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial reset to IDLE");
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Transition IDLE -> CONNECTING");
            test_num = 2;
            reset_dut();
            start_connect = 1;
            @(posedge clk);
            #1;
            start_connect = 0;
            #1;

            check_outputs(STATE_CONNECTING);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Transition IDLE -> CONNECTING -> CONNECTED");
            test_num = 3;
            reset_dut();

            start_connect = 1;
            @(posedge clk);
            #1;
            start_connect = 0;

            connection_success = 1;
            @(posedge clk);
            #1;
            connection_success = 0;
            #1;

            check_outputs(STATE_CONNECTED);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Transition IDLE -> CONNECTING -> IDLE (on connection_fail)");
            test_num = 4;
            reset_dut();

            start_connect = 1;
            @(posedge clk);
            #1;
            start_connect = 0;

            connection_fail = 1;
            @(posedge clk);
            #1;
            connection_fail = 0;
            #1;

            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reset from CONNECTED to IDLE");
            test_num = 5;
            reset_dut();

            start_connect = 1;
            @(posedge clk);
            #1 start_connect = 0;
            connection_success = 1;
            @(posedge clk);
            #1 connection_success = 0;


            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            #1;

            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Persistence in CONNECTED (Ignore start_connect)");
            test_num = 6;
            reset_dut();

            start_connect = 1;
            @(posedge clk);
            #1 start_connect = 0;
            connection_success = 1;
            @(posedge clk);
            #1 connection_success = 0;


            start_connect = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(STATE_CONNECTED);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_fsm Testbench");
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
        $dumpvars(0,clk, connection_fail, connection_success, rst, start_connect, state);
    end

endmodule
