`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg error;
    reg rst;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .error(error),
        .rst(rst),
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
            rst = 1;
            start = 0;
            error = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset logic - Checking for IDLE state");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Transition IDLE -> ACTIVE via start signal");
            test_num = 2;
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);


            #1;



            check_outputs(STATE_ACTIVE);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Transition IDLE -> ERROR via error signal");
            test_num = 3;
            reset_dut();

            @(posedge clk);
            error = 1;
            @(posedge clk);


            #1;



            check_outputs(STATE_ERROR);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Transition ACTIVE -> ERROR");
            test_num = 4;
            reset_dut();


            @(posedge clk);
            start = 1;
            @(posedge clk);


            error = 1;
            @(posedge clk);


            #1;



            check_outputs(STATE_ERROR);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Transition ACTIVE -> IDLE when start is removed");
            test_num = 5;
            reset_dut();


            @(posedge clk);
            start = 1;
            @(posedge clk);


            start = 0;
            @(posedge clk);


            #1;



            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Recovery from ERROR state via Reset");
            test_num = 6;
            reset_dut();


            @(posedge clk);
            error = 1;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);


            #1;



            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Priority check - error signal while start is active");
            test_num = 7;
            reset_dut();

            @(posedge clk);
            start = 1;
            error = 1;
            @(posedge clk);


            #1;



            check_outputs(STATE_ERROR);
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
        $dumpvars(0,clk, error, rst, start, state);
    end

endmodule
