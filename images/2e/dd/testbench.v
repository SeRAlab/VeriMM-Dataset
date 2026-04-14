`timescale 1ns/1ps

module reset_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg error;
    reg rst_n;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reset_controller dut (
        .clk(clk),
        .error(error),
        .rst_n(rst_n),
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
        error = 0;
        #(15);
        rst_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset to IDLE state", test_num);
        reset_dut();


        #1;



        check_outputs(IDLE);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Transition from IDLE to RUN", test_num);
        reset_dut();
        error = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(RUN);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Transition to ERROR state", test_num);
        reset_dut();
        @(posedge clk);
        #1;
        error = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(ERROR);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Async reset from ERROR state", test_num);
        reset_dut();
        error = 1;
        @(posedge clk);
        @(posedge clk);
        #2;
        rst_n = 0;
        #1;
        #1;

        check_outputs(IDLE);
        rst_n = 1;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Ensure ERROR state is sticky until reset", test_num);
        reset_dut();
        error = 1;
        @(posedge clk);
        #1;
        error = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(ERROR);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset priority over error", test_num);
        reset_dut();
        error = 1;
        rst_n = 0;
        #5;
        #1;

        check_outputs(IDLE);
        rst_n = 1;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reset_controller Testbench");
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
        $dumpvars(0,clk, error, rst_n, state);
    end

endmodule
