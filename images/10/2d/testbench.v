`timescale 1ns/1ps

module nvme_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cmd_done;
    reg rst_n;
    reg start_cmd;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_controller dut (
        .clk(clk),
        .cmd_done(cmd_done),
        .rst_n(rst_n),
        .start_cmd(start_cmd),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            start_cmd = 0;
            cmd_done = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transition IDLE to COMMAND", test_num);
            reset_dut();

            @(posedge clk);
            start_cmd = 1;
            @(posedge clk);
            #1 start_cmd = 0;

            #1;


            check_outputs(COMMAND);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transition COMMAND to DONE", test_num);
            reset_dut();


            @(posedge clk);
            start_cmd = 1;
            @(posedge clk);
            #1 start_cmd = 0;


            cmd_done = 1;
            @(posedge clk);
            #1 cmd_done = 0;

            #1;


            check_outputs(DONE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Full Cycle Return to IDLE", test_num);
            reset_dut();


            @(posedge clk);
            start_cmd = 1;
            @(posedge clk);
            #1 start_cmd = 0;


            cmd_done = 1;
            @(posedge clk);
            #1 cmd_done = 0;


            @(posedge clk);
            #1;

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Hold in COMMAND State", test_num);
            reset_dut();

            @(posedge clk);
            start_cmd = 1;
            @(posedge clk);
            #1 start_cmd = 0;


            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(COMMAND);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Ignore start_cmd when busy", test_num);
            reset_dut();


            @(posedge clk);
            start_cmd = 1;
            @(posedge clk);
            #1;


            start_cmd = 1;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(COMMAND);
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
        $dumpvars(0,clk, cmd_done, rst_n, start_cmd, state);
    end

endmodule
