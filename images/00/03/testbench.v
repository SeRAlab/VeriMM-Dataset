`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connection_success;
    reg disconnection_success;
    reg reset;
    reg start_connection;
    reg start_disconnection;
    wire [1:0] current_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .connection_success(connection_success),
        .disconnection_success(disconnection_success),
        .reset(reset),
        .start_connection(start_connection),
        .start_disconnection(start_disconnection),
        .current_state(current_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        start_connection = 0;
        connection_success = 0;
        start_disconnection = 0;
        disconnection_success = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Full Cycle (IDLE -> CONNECTING -> CONNECTED -> DISCONNECTING -> IDLE)", test_num);
        reset_dut();


        @(posedge clk);
        start_connection = 1;
        @(posedge clk);
        start_connection = 0;


        @(posedge clk);
        connection_success = 1;
        @(posedge clk);
        connection_success = 0;


        @(posedge clk);
        start_disconnection = 1;
        @(posedge clk);
        start_disconnection = 0;


        @(posedge clk);
        disconnection_success = 1;
        @(posedge clk);
        disconnection_success = 0;

        #1 #1;
 check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: IDLE to CONNECTING transition", test_num);
        reset_dut();

        @(posedge clk);
        start_connection = 1;
        @(posedge clk);
        start_connection = 0;

        #1 #1;
 check_outputs(2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: IDLE to CONNECTED transition", test_num);
        reset_dut();


        @(posedge clk);
        start_connection = 1;
        @(posedge clk);
        start_connection = 0;


        @(posedge clk);
        connection_success = 1;
        @(posedge clk);
        connection_success = 0;

        #1 #1;
 check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Stay in IDLE if no start signal", test_num);
        reset_dut();

        repeat(5) @(posedge clk);

        #1 #1;
 check_outputs(2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Ignore success signal while in IDLE", test_num);
        reset_dut();

        @(posedge clk);
        connection_success = 1;
        @(posedge clk);
        connection_success = 0;

        #1 #1;
 check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reach DISCONNECTING state", test_num);
        reset_dut();


        @(posedge clk);
        start_connection = 1;
        @(posedge clk);
        start_connection = 0;


        @(posedge clk);
        connection_success = 1;
        @(posedge clk);
        connection_success = 0;


        @(posedge clk);
        start_disconnection = 1;
        @(posedge clk);
        start_disconnection = 0;

        #1 #1;
 check_outputs(2'b11);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Async Reset from CONNECTED state", test_num);
        reset_dut();


        @(posedge clk);
        start_connection = 1;
        @(posedge clk);
        start_connection = 0;
        @(posedge clk);
        connection_success = 1;
        @(posedge clk);
        connection_success = 0;


        @(posedge clk);
        reset = 1;
        @(posedge clk);
        reset = 0;

        #1 #1;
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
        $display("sata_controller Testbench");
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
        input [1:0] expected_current_state;
        begin
            if (expected_current_state === (expected_current_state ^ current_state ^ expected_current_state)) begin
                $display("PASS");
                $display("  Outputs: current_state=%h",
                         current_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_state=%h",
                         expected_current_state);
                $display("  Got:      current_state=%h",
                         current_state);
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
        $dumpvars(0,clk, connection_success, disconnection_success, reset, start_connection, start_disconnection, current_state);
    end

endmodule
