`timescale 1ns/1ps

module bluetooth_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connection_done;
    reg disconnect;
    reg reset;
    reg start_connection;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_controller dut (
        .clk(clk),
        .connection_done(connection_done),
        .disconnect(disconnect),
        .reset(reset),
        .start_connection(start_connection),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            connection_done = 0;
            disconnect = 0;
            start_connection = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset to IDLE", test_num);
            reset_dut();
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: IDLE to CONNECTING via start_connection", test_num);
            reset_dut();
            @(posedge clk);
            start_connection = 1;
            @(posedge clk);
            start_connection = 0;
            #1;
            #1;

            check_outputs(CONNECTING);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: CONNECTING to CONNECTED via connection_done", test_num);
            reset_dut();

            @(posedge clk);
            start_connection = 1;
            @(posedge clk);
            start_connection = 0;

            connection_done = 1;
            @(posedge clk);
            connection_done = 0;
            #1;
            #1;

            check_outputs(CONNECTED);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: CONNECTED to IDLE via disconnect", test_num);
            reset_dut();

            @(posedge clk);
            start_connection = 1;
            @(posedge clk);
            start_connection = 0;

            connection_done = 1;
            @(posedge clk);
            connection_done = 0;

            disconnect = 1;
            @(posedge clk);
            disconnect = 0;
            #1;
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Verify state holds when no signals are triggered", test_num);
            reset_dut();

            @(posedge clk);
            start_connection = 1;
            @(posedge clk);
            start_connection = 0;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(CONNECTING);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Verify IDLE ignores connection_done", test_num);
            reset_dut();
            @(posedge clk);
            connection_done = 1;
            @(posedge clk);
            connection_done = 0;
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
        $display("bluetooth_controller Testbench");
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
        $dumpvars(0,clk, connection_done, disconnect, reset, start_connection, state);
    end

endmodule
