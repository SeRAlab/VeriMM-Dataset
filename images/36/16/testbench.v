`timescale 1ns/1ps

module wifi_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [1:0] state_input;
    wire [1:0] current_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_module dut (
        .clk(clk),
        .reset(reset),
        .state_input(state_input),
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
            state_input = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            state_input = SCANNING;
            @(posedge clk);
            #1;
            #1;

            check_outputs(SCANNING);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            state_input = CONNECTING;
            @(posedge clk);
            #1;
            #1;

            check_outputs(CONNECTING);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            state_input = CONNECTED;
            @(posedge clk);
            #1;
            #1;

            check_outputs(CONNECTED);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            state_input = SCANNING;
            @(posedge clk);
            #1;

            state_input = CONNECTING;
            @(posedge clk);
            #1;
            #1;

            check_outputs(CONNECTING);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            state_input = CONNECTED;
            @(posedge clk);
            #1;

            state_input = IDLE;
            @(posedge clk);
            #1;
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            state_input = SCANNING;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
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
        $display("wifi_module Testbench");
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
        $dumpvars(0,clk, reset, state_input, current_state);
    end

endmodule
