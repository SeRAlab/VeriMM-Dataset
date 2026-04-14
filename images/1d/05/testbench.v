`timescale 1ns/1ps

module slam_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg complete;
    reg mapping_done;
    reg rst;
    reg start;
    wire [1:0] state_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_fsm dut (
        .clk(clk),
        .complete(complete),
        .mapping_done(mapping_done),
        .rst(rst),
        .start(start),
        .state_out(state_out)
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
        mapping_done = 0;
        complete = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Full sequence IDLE -> LOCALIZE -> MAPPING -> COMPLETE", test_num);


        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;


        mapping_done = 1;
        @(posedge clk);
        mapping_done = 0;


        complete = 1;
        @(posedge clk);
        complete = 0;

        #2;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Sequence IDLE -> LOCALIZE -> MAPPING", test_num);


        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;


        mapping_done = 1;
        @(posedge clk);
        mapping_done = 0;

        #2;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Sequence IDLE -> LOCALIZE", test_num);


        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        #2;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Stay in IDLE without start signal", test_num);

        @(posedge clk);

        @(posedge clk);

        #2;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Reset while in MAPPING state", test_num);


        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        mapping_done = 1;
        @(posedge clk);
        mapping_done = 0;


        rst = 1;
        @(posedge clk);
        rst = 0;

        #2;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Trigger 'complete' while in IDLE (should stay IDLE)", test_num);

        @(posedge clk);
        complete = 1;
        @(posedge clk);
        complete = 0;

        #2;
        #1;

        check_outputs(2'b00);
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
        input [1:0] expected_state_out;
        begin
            if (expected_state_out === (expected_state_out ^ state_out ^ expected_state_out)) begin
                $display("PASS");
                $display("  Outputs: state_out=%h",
                         state_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_out=%h",
                         expected_state_out);
                $display("  Got:      state_out=%h",
                         state_out);
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
        $dumpvars(0,clk, complete, mapping_done, rst, start, state_out);
    end

endmodule
