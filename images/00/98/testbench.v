`timescale 1ns/1ps

module slam_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg localize_done;
    reg map_ready;
    reg reset;
    reg start;
    wire [1:0] current_state;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_fsm dut (
        .clk(clk),
        .localize_done(localize_done),
        .map_ready(map_ready),
        .reset(reset),
        .start(start),
        .current_state(current_state),
        .error(error)
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
            map_ready = 0;
            localize_done = 0;
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


            check_outputs(INIT, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            start = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(MAP, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            map_ready = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(LOCALIZE, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            start = 1;
            @(posedge clk);
            #1;

            start = 0;
            map_ready = 1;
            @(posedge clk);
            #1;

            map_ready = 0;
            localize_done = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(MAP, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            start = 1;
            #2;

            #1;


            check_outputs(INIT, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            map_ready = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(MAP, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_fsm Testbench");
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
        input expected_error;
        begin
            if (expected_current_state === (expected_current_state ^ current_state ^ expected_current_state) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: current_state=%h, error=%b",
                         current_state, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_state=%h, error=%b",
                         expected_current_state, expected_error);
                $display("  Got:      current_state=%h, error=%b",
                         current_state, error);
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
        $dumpvars(0,clk, localize_done, map_ready, reset, start, current_state, error);
    end

endmodule
