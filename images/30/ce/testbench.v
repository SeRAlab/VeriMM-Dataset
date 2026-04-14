`timescale 1ns/1ps

module bluetooth_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg conn_success;
    reg disconnect;
    reg reset;
    reg start_conn;
    wire [1:0] current_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_fsm dut (
        .clk(clk),
        .conn_success(conn_success),
        .disconnect(disconnect),
        .reset(reset),
        .start_conn(start_conn),
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
            start_conn = 0;
            conn_success = 0;
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
            $display("\nTest %0d: Normal Connection Flow", test_num);
            reset_dut();


            start_conn = 1;
            @(posedge clk); #1;
            start_conn = 0;


            conn_success = 1;
            @(posedge clk); #1;
            conn_success = 0;

            #1;


            check_outputs(CONNECTED);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Full State Cycle to Disconnected", test_num);
            reset_dut();

            start_conn = 1;
            @(posedge clk); #1;
            start_conn = 0;

            conn_success = 1;
            @(posedge clk); #1;
            conn_success = 0;

            disconnect = 1;
            @(posedge clk); #1;
            disconnect = 0;

            #1;


            check_outputs(DISCONNECTED);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Reset during Connecting phase", test_num);
            reset_dut();

            start_conn = 1;
            @(posedge clk); #1;
            start_conn = 0;


            reset = 1;
            @(posedge clk); #1;
            reset = 0;

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Robustness check (Invalid signals in IDLE)", test_num);
            reset_dut();


            conn_success = 1;
            disconnect = 1;
            @(posedge clk); #1;
            conn_success = 0;
            disconnect = 0;

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Return to IDLE from DISCONNECTED", test_num);
            reset_dut();


            start_conn = 1; @(posedge clk); #1; start_conn = 0;
            conn_success = 1; @(posedge clk); #1; conn_success = 0;
            disconnect = 1; @(posedge clk); #1; disconnect = 0;


            reset = 1;
            @(posedge clk); #1;
            reset = 0;

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
        $display("bluetooth_fsm Testbench");
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
        $dumpvars(0,clk, conn_success, disconnect, reset, start_conn, current_state);
    end

endmodule
