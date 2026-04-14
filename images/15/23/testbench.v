`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg start_read;
    reg start_write;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .clk(clk),
        .start_read(start_read),
        .start_write(start_write),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start_read = 0;
            start_write = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Initial IDLE State");
            reset_dut();
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: IDLE to READ Transition");
            reset_dut();
            start_read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(READ);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: IDLE to WRITE Transition");
            reset_dut();
            start_write = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(WRITE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: READ to IDLE Transition");
            reset_dut();

            start_read = 1;
            @(posedge clk);
            #1;

            start_read = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: WRITE to IDLE Transition");
            reset_dut();

            start_write = 1;
            @(posedge clk);
            #1;

            start_write = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Simultaneous Read and Write (Priority Check)");
            reset_dut();
            start_read = 1;
            start_write = 1;
            @(posedge clk);
            #1;

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
        $display("sd_card_controller Testbench");
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
        $dumpvars(0,clk, start_read, start_write, state);
    end

endmodule
