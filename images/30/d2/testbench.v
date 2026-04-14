`timescale 1ns/1ps

module wifi_state_machine_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connection_success;
    reg reset;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_state_machine dut (
        .clk(clk),
        .connection_success(connection_success),
        .reset(reset),
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
            reset = 1;
            start = 0;
            connection_success = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Initial IDLE state check");
            test_num = 1;
            reset_dut();

            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: IDLE to CONNECTING via 'start'");
            test_num = 2;
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Full path IDLE -> CONNECTING -> CONNECTED");
            test_num = 3;
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            connection_success = 1;
            @(posedge clk);
            connection_success = 0;
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Persistence in CONNECTING state");
            test_num = 4;
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Persistence in CONNECTED state");
            test_num = 5;
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            connection_success = 1;
            @(posedge clk);
            connection_success = 0;

            repeat(5) @(posedge clk);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Reset from CONNECTED state");
            test_num = 6;
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            connection_success = 1;
            repeat(2) @(posedge clk);

            reset = 1;
            @(posedge clk);
            reset = 0;
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Ignore connection_success in IDLE");
            test_num = 7;
            reset_dut();
            connection_success = 1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_state_machine Testbench");
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
        $dumpvars(0,clk, connection_success, reset, start, state);
    end

endmodule
