`timescale 1ns/1ps

module bluetooth_control_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connection_success;
    reg disconnect;
    reg reset;
    reg start_connect;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_control dut (
        .clk(clk),
        .connection_success(connection_success),
        .disconnect(disconnect),
        .reset(reset),
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
            reset = 1;
            start_connect = 0;
            disconnect = 0;
            connection_success = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Reset state check");
            test_num = test_num + 1;
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: IDLE to CONNECTING");
            test_num = test_num + 1;
            reset_dut();
            start_connect = 1;
            @(posedge clk);
            #1;
            start_connect = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: CONNECTING to CONNECTED");
            test_num = test_num + 1;
            reset_dut();

            start_connect = 1;
            @(posedge clk);
            #1;
            start_connect = 0;

            connection_success = 1;
            @(posedge clk);
            #1;
            connection_success = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: CONNECTED to DISCONNECTED");
            test_num = test_num + 1;
            reset_dut();

            start_connect = 1;
            @(posedge clk);
            #1;
            start_connect = 0;
            connection_success = 1;
            @(posedge clk);
            #1;
            connection_success = 0;

            disconnect = 1;
            @(posedge clk);
            #1;
            disconnect = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: DISCONNECTED to CONNECTING (Re-initiate)");
            test_num = test_num + 1;
            reset_dut();

            start_connect = 1; @(posedge clk); #1; start_connect = 0;
            connection_success = 1; @(posedge clk); #1; connection_success = 0;
            disconnect = 1; @(posedge clk); #1; disconnect = 0;


            start_connect = 1;
            @(posedge clk);
            #1;
            start_connect = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Invalid input check (connection_success in IDLE)");
            test_num = test_num + 1;
            reset_dut();

            connection_success = 1;
            @(posedge clk);
            #1;
            connection_success = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Mid-process Reset check");
            test_num = test_num + 1;
            reset_dut();

            start_connect = 1; @(posedge clk); #1; start_connect = 0;
            connection_success = 1; @(posedge clk); #1; connection_success = 0;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;

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
        $display("bluetooth_control Testbench");
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
        $dumpvars(0,clk, connection_success, disconnect, reset, start_connect, state);
    end

endmodule
