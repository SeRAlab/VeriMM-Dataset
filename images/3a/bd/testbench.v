`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg error;
    reg reset;
    reg start;
    reg stop;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .error(error),
        .reset(reset),
        .start(start),
        .stop(stop),
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
            start = 0;
            stop = 0;
            error = 0;
            @(negedge clk);
            reset = 0;
            test_num = test_num + 1;
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
            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;
            #1;

            check_outputs(ACTIVE);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;
            stop = 1;
            @(negedge clk);
            stop = 0;
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;
            error = 1;
            @(negedge clk);
            error = 0;
            #1;

            check_outputs(ERROR);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge clk);
            error = 1;
            @(negedge clk);
            error = 0;
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(negedge clk);
            stop = 1;
            @(negedge clk);
            stop = 0;
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            @(negedge clk);
            start = 1;
            @(negedge clk);
            start = 0;
            error = 1;
            @(negedge clk);
            error = 0;
            reset = 1;
            @(negedge clk);
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
        $dumpvars(0,clk, error, reset, start, stop, state);
    end

endmodule
