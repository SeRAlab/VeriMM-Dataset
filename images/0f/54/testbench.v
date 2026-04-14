`timescale 1ns/1ps

module bluetooth_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connect;
    reg disconnect;
    reg rst;
    reg start_scan;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_controller dut (
        .clk(clk),
        .connect(connect),
        .disconnect(disconnect),
        .rst(rst),
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
        rst = 1;
        start_scan = 0;
        connect = 0;
        disconnect = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest %0d: Full Connection Sequence (IDLE -> SCAN -> CONNECTING -> CONNECTED)", test_num);
        reset_dut();


        @(posedge clk);
        start_scan = 1;
        @(posedge clk);
        start_scan = 0;


        @(posedge clk);
        connect = 1;
        @(posedge clk);
        connect = 0;


        repeat(2) @(posedge clk);

        #1 #1;
 check_outputs(2'b11);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest %0d: Transition to SCANNING", test_num);
        reset_dut();

        @(posedge clk);
        start_scan = 1;
        @(posedge clk);
        start_scan = 0;

        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest %0d: Connect then Disconnect", test_num);
        reset_dut();


        start_scan = 1; @(posedge clk); start_scan = 0;
        connect = 1;    @(posedge clk); connect = 0;
        repeat(2) @(posedge clk);


        disconnect = 1;
        @(posedge clk);
        disconnect = 0;

        repeat(1) @(posedge clk);
        #1 #1;
 check_outputs(2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest %0d: Reset during CONNECTING state", test_num);
        reset_dut();


        start_scan = 1; @(posedge clk); start_scan = 0;

        connect = 1;    @(posedge clk); connect = 0;


        #2 rst = 1;
        repeat(2) @(posedge clk);
        #1 rst = 0;

        @(posedge clk);
        #1 #1;
 check_outputs(2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest %0d: Verify no transition from SCANNING if connect is 0", test_num);
        reset_dut();

        @(posedge clk);
        start_scan = 1;
        @(posedge clk);
        start_scan = 0;


        repeat(5) @(posedge clk);

        #1 #1;
 check_outputs(2'b01);
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
        $dumpvars(0,clk, connect, disconnect, rst, start_scan, state);
    end

endmodule
