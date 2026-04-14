`timescale 1ns/1ps

module wifi_status_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg disconnect;
    reg rst;
    reg start_connect;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_status_controller dut (
        .clk(clk),
        .disconnect(disconnect),
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
        disconnect = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning testcase001: Verify reset state is OFF");
        reset_dut();
        #1;
        #1;

        check_outputs(OFF);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: OFF to CONNECTING");
        reset_dut();
        @(posedge clk);
        start_connect = 1;
        @(posedge clk);
        #1 start_connect = 0;
        #1;

        check_outputs(CONNECTING);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: CONNECTING to CONNECTED");
        reset_dut();
        @(posedge clk);
        start_connect = 1;
        @(posedge clk);
        #1 start_connect = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(CONNECTED);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: CONNECTED to DISCONNECTED");
        reset_dut();

        @(posedge clk);
        start_connect = 1;
        @(posedge clk);
        #1 start_connect = 0;
        @(posedge clk);

        #1 disconnect = 1;
        @(posedge clk);
        #1 disconnect = 0;
        #1;

        check_outputs(DISCONNECTED);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: DISCONNECTED back to OFF");
        reset_dut();

        @(posedge clk);
        start_connect = 1;
        @(posedge clk);
        #1 start_connect = 0;
        @(posedge clk);

        #1 disconnect = 1;
        @(posedge clk);
        #1 disconnect = 0;

        @(posedge clk);
        #1;
        #1;

        check_outputs(OFF);
    end
        endtask

    task testcase006;

    begin
        $display("\nRunning testcase006: No transition from OFF without signal");
        reset_dut();
        start_connect = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(OFF);
    end
        endtask

    task testcase007;

    begin
        $display("\nRunning testcase007: Mid-process Reset");
        reset_dut();
        @(posedge clk);
        start_connect = 1;
        @(posedge clk);
        #1 rst = 1;
        @(posedge clk);
        #1 rst = 0;
        #1;

        check_outputs(OFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_status_controller Testbench");
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
        $dumpvars(0,clk, disconnect, rst, start_connect, state);
    end

endmodule
