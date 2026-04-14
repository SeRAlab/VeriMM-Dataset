`timescale 1ns/1ps

module nvme_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] cmd;
    reg reset;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_controller dut (
        .clk(clk),
        .cmd(cmd),
        .reset(reset),
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
            cmd = CMD_NONE;
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
            $display("\nRunning Testcase 001: Power-on Reset to IDLE");
            reset_dut();

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase 002: READ Command Sequence (IDLE -> READ -> DONE)");
            reset_dut();

            cmd = CMD_READ;
            @(posedge clk);
            #1;
            cmd = CMD_NONE;
            @(posedge clk);
            #1;


            #1;



            check_outputs(DONE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase 003: WRITE Command Sequence (IDLE -> WRITE -> DONE)");
            reset_dut();

            cmd = CMD_WRITE;
            @(posedge clk);
            #1;
            cmd = CMD_NONE;
            @(posedge clk);
            #1;


            #1;



            check_outputs(DONE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase 004: Persistence in DONE state until reset");
            reset_dut();


            cmd = CMD_READ;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            cmd = CMD_WRITE;
            @(posedge clk);
            @(posedge clk);
            #1;



            #1;




            check_outputs(DONE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase 005: Reset during READ state");
            reset_dut();

            cmd = CMD_READ;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;
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
        $display("nvme_controller Testbench");
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
        $dumpvars(0,clk, cmd, reset, state);
    end

endmodule
