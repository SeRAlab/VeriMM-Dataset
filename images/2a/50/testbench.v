`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg error;
    reg rst;
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
        .rst(rst),
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
        rst = 1;
        start = 0;
        stop = 0;
        error = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial State after Reset", test_num);
        reset_dut();
        #1;

        check_outputs(IDLE);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: IDLE to ACTIVE transition", test_num);
        reset_dut();
        start = 1;
        @(posedge clk);
        #1 start = 0;
        #1;

        check_outputs(ACTIVE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: ACTIVE to IDLE transition via stop signal", test_num);
        reset_dut();

        start = 1;
        @(posedge clk);
        #1 start = 0;

        stop = 1;
        @(posedge clk);
        #1 stop = 0;
        #1;

        check_outputs(IDLE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: IDLE to ERROR transition", test_num);
        reset_dut();
        error = 1;
        @(posedge clk);
        #1 error = 0;
        #1;

        check_outputs(ERROR);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: ACTIVE to ERROR transition", test_num);
        reset_dut();
        start = 1;
        @(posedge clk);
        #1 start = 0;
        error = 1;
        @(posedge clk);
        #1 error = 0;
        #1;

        check_outputs(ERROR);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Error priority over Start in IDLE", test_num);
        reset_dut();
        start = 1;
        error = 1;
        @(posedge clk);
        #1 start = 0; error = 0;
        #1;

        check_outputs(ERROR);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Error priority over Stop in ACTIVE", test_num);
        reset_dut();

        start = 1;
        @(posedge clk);
        #1 start = 0;

        stop = 1;
        error = 1;
        @(posedge clk);
        #1 stop = 0; error = 0;
        #1;

        check_outputs(ERROR);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Stop signal in IDLE state", test_num);
        reset_dut();
        stop = 1;
        @(posedge clk);
        #1 stop = 0;
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
        testcase008();
        
        
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
        $dumpvars(0,clk, error, rst, start, stop, state);
    end

endmodule
