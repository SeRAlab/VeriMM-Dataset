`timescale 1ns/1ps

module nvme_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg command;
    reg reset;
    wire [1:0] current_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_controller dut (
        .clk(clk),
        .command(command),
        .reset(reset),
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
        command = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Reset logic");
        reset_dut();

        #1;


        check_outputs(STATE_IDLE);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Transition IDLE to PROCESSING");
        reset_dut();

        command = 1;
        @(posedge clk);
        #1;
        command = 0;

        #1;


        check_outputs(STATE_PROCESSING);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Transition PROCESSING to DONE");
        reset_dut();

        command = 1;
        @(posedge clk);
        #1;
        command = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(STATE_DONE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Return to IDLE from DONE");
        reset_dut();

        command = 1;
        @(posedge clk);
        #1;
        command = 0;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(STATE_IDLE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Reset during PROCESSING state");
        reset_dut();

        command = 1;
        @(posedge clk);
        #1;

        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;

        #1;


        check_outputs(STATE_IDLE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Multiple sequential commands");
        reset_dut();


        command = 1;
        @(posedge clk);
        #1;
        command = 0;
        @(posedge clk);
        #1;
        @(posedge clk);
        #1;


        command = 1;
        @(posedge clk);
        #1;
        command = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(STATE_DONE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nvme_controller Testbench");
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
        $dumpvars(0,clk, command, reset, current_state);
    end

endmodule
