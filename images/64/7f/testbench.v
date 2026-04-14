`timescale 1ns/1ps

module simple_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg signal;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_fsm dut (
        .clk(clk),
        .reset(reset),
        .signal(signal),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            signal = 0;
            #15;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Testing Reset to IDLE");
            reset_dut();

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: IDLE to LOAD (signal=1)");
            reset_dut();
            @(negedge clk);
            signal = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(LOAD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Transition to EXECUTE");
            reset_dut();
            @(negedge clk);
            signal = 1;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(EXECUTE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Full state cycle back to IDLE");
            reset_dut();
            @(negedge clk);
            signal = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Hold LOAD state when signal is 0");
            reset_dut();
            @(negedge clk);
            signal = 1;
            @(posedge clk);
            @(negedge clk);
            signal = 0;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(LOAD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Asynchronous reset from EXECUTE");
            reset_dut();
            @(negedge clk);
            signal = 1;
            @(posedge clk);
            @(posedge clk);
            #2;
            reset = 1;
            #2;
            #1;

            check_outputs(IDLE);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_fsm Testbench");
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
        $dumpvars(0,clk, reset, signal, state);
    end

endmodule
