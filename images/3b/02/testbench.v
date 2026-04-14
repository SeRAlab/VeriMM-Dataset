`timescale 1ns/1ps

module bluetooth_manager_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg confirm_connection;
    reg connect;
    reg disconnect;
    reg reset;
    reg start_scan;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_manager dut (
        .clk(clk),
        .confirm_connection(confirm_connection),
        .connect(connect),
        .disconnect(disconnect),
        .reset(reset),
        .start_scan(start_scan),
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
        start_scan = 0;
        connect = 0;
        confirm_connection = 0;
        disconnect = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Transition IDLE -> SCANNING -> CONNECTING -> CONNECTED", test_num);
        reset_dut();


        @(posedge clk); #1; start_scan = 1;
        @(posedge clk); #1; start_scan = 0;


        connect = 1;
        @(posedge clk); #1; connect = 0;


        confirm_connection = 1;
        @(posedge clk); #1; confirm_connection = 0;

        #1;


        check_outputs(2'b11);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Transition IDLE -> ... -> CONNECTED -> IDLE", test_num);
        reset_dut();


        @(posedge clk); #1; start_scan = 1;
        @(posedge clk); #1; start_scan = 0; connect = 1;
        @(posedge clk); #1; connect = 0; confirm_connection = 1;
        @(posedge clk); #1; confirm_connection = 0;


        disconnect = 1;
        @(posedge clk); #1; disconnect = 0;

        #1;


        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Transition IDLE -> SCANNING and stay", test_num);
        reset_dut();

        @(posedge clk); #1; start_scan = 1;
        @(posedge clk); #1; start_scan = 0;


        repeat(2) @(posedge clk);

        #1;


        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Transition IDLE -> SCANNING -> CONNECTING and stay", test_num);
        reset_dut();

        @(posedge clk); #1; start_scan = 1;
        @(posedge clk); #1; start_scan = 0; connect = 1;
        @(posedge clk); #1; connect = 0;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(2'b10);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset while in CONNECTING state", test_num);
        reset_dut();


        @(posedge clk); #1; start_scan = 1;
        @(posedge clk); #1; start_scan = 0; connect = 1;
        @(posedge clk); #1; connect = 0;


        reset = 1;
        @(posedge clk); #1; reset = 0;

        #1;


        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Verify 'connect' is ignored in IDLE state", test_num);
        reset_dut();


        @(posedge clk); #1; connect = 1;
        @(posedge clk); #1; connect = 0;

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
        $display("bluetooth_manager Testbench");
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
        $dumpvars(0,clk, confirm_connection, connect, disconnect, reset, start_scan, state);
    end

endmodule
