`timescale 1ns/1ps

module wifi_connection_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg connection_success;
    reg reset;
    reg start_connection;
    wire [1:0] current_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_connection_fsm dut (
        .clock(clock),
        .connection_success(connection_success),
        .reset(reset),
        .start_connection(start_connection),
        .current_state(current_state)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            start_connection = 0;
            connection_success = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: IDLE to CONNECTING transition", test_num);
            reset_dut();

            @(posedge clock);
            start_connection = 1;
            @(posedge clock);
            #1 start_connection = 0;


            @(posedge clock);
            #1;


            #1;



            check_outputs(STATE_CONNECTING);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: IDLE to CONNECTED full sequence", test_num);
            reset_dut();


            @(posedge clock);
            start_connection = 1;
            @(posedge clock);
            #1 start_connection = 0;


            @(posedge clock);
            connection_success = 1;
            @(posedge clock);
            #1 connection_success = 0;

            @(posedge clock);
            #1;


            #1;



            check_outputs(STATE_CONNECTED);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Stay in CONNECTING state", test_num);
            reset_dut();


            @(posedge clock);
            start_connection = 1;
            @(posedge clock);
            #1 start_connection = 0;


            repeat(3) @(posedge clock);
            #1;


            #1;



            check_outputs(STATE_CONNECTING);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Reset while in CONNECTED", test_num);
            reset_dut();


            @(posedge clock);
            start_connection = 1;
            @(posedge clock);
            #1 start_connection = 0;
            @(posedge clock);
            connection_success = 1;
            @(posedge clock);
            #1 connection_success = 0;


            @(posedge clock);
            reset = 1;
            @(posedge clock);
            #1 reset = 0;

            @(posedge clock);
            #1;


            #1;



            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Stay in IDLE if no start signal", test_num);
            reset_dut();


            @(posedge clock);
            connection_success = 1;
            repeat(2) @(posedge clock);
            #1;


            #1;



            check_outputs(STATE_IDLE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_connection_fsm Testbench");
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
        $dumpvars(0,clock, connection_success, reset, start_connection, current_state);
    end

endmodule
