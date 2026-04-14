`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg complete;
    reg data_valid;
    reg reset;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .complete(complete),
        .data_valid(data_valid),
        .reset(reset),
        .start(start),
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
            start = 0;
            data_valid = 0;
            complete = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Check IDLE state after reset", test_num);
            reset_dut();
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transition IDLE to READ on 'start'", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;
            #1;

            check_outputs(READ);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transition READ to WRITE on 'data_valid'", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;
            data_valid = 1;
            @(negedge clk);
            data_valid = 0;
            #1;

            check_outputs(WRITE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Full cycle back to IDLE on 'complete'", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;
            data_valid = 1;
            @(negedge clk);
            data_valid = 0;
            complete = 1;
            @(negedge clk);
            complete = 0;
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Stay in READ if 'data_valid' is low", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;
            data_valid = 0;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(READ);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Stay in WRITE if 'complete' is low", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;
            data_valid = 1;
            @(negedge clk);
            data_valid = 0;
            complete = 0;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(WRITE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Multiple triggers (start + data_valid) from IDLE", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            data_valid = 1;
            @(negedge clk);
            #1;

            check_outputs(READ);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
        $dumpvars(0,clk, complete, data_valid, reset, start, state);
    end

endmodule
