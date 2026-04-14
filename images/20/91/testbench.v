`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start_rx;
    reg start_tx;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .reset(reset),
        .start_rx(start_rx),
        .start_tx(start_tx),
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
            start_rx = 0;
            start_tx = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Check IDLE state after Reset", test_num);
            reset_dut();
            #1;

            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transition IDLE -> TRANSMIT", test_num);
            reset_dut();
            start_tx = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(STATE_TRANSMIT);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Transition IDLE -> RECEIVE", test_num);
            reset_dut();
            start_rx = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(STATE_RECEIVE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Return TRANSMIT -> IDLE", test_num);
            reset_dut();
            start_tx = 1;
            @(posedge clk);
            #1 start_tx = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Return RECEIVE -> IDLE", test_num);
            reset_dut();
            start_rx = 1;
            @(posedge clk);
            #1 start_rx = 0;
            @(posedge clk);
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
        $display("ethernet_mac_controller Testbench");
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
        $dumpvars(0,clk, reset, start_rx, start_tx, state);
    end

endmodule
