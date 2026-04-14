`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg err;
    reg req;
    reg rst;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .err(err),
        .req(req),
        .rst(rst),
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
        req = 0;
        err = 0;
        @(posedge clk);
        #2 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("\nTest Case 001: Verify IDLE state after Reset");
        reset_dut();
        #1;

        check_outputs(STATE_IDLE);
    end
        endtask

    task testcase002;

    begin
        $display("\nTest Case 002: IDLE to ACTIVE transition");
        reset_dut();
        req = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(STATE_ACTIVE);
    end
        endtask

    task testcase003;

    begin
        $display("\nTest Case 003: ACTIVE to IDLE (req cleared)");
        reset_dut();
        req = 1;
        @(posedge clk);
        #1;
        req = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(STATE_IDLE);
    end
        endtask

    task testcase004;

    begin
        $display("\nTest Case 004: ACTIVE to ERROR transition");
        reset_dut();
        req = 1;
        @(posedge clk);
        #1;
        err = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(STATE_ERROR);
    end
        endtask

    task testcase005;

    begin
        $display("\nTest Case 005: ERROR to IDLE (err resolved)");
        reset_dut();
        req = 1;
        @(posedge clk);
        #1;
        err = 1;
        @(posedge clk);
        #1;
        err = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(STATE_IDLE);
    end
        endtask

    task testcase006;

    begin
        $display("\nTest Case 006: ERROR to IDLE (req cleared)");
        reset_dut();
        req = 1;
        @(posedge clk);
        #1;
        err = 1;
        @(posedge clk);
        #1;
        req = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(STATE_IDLE);
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
        $dumpvars(0,clk, err, req, rst, state);
    end

endmodule
