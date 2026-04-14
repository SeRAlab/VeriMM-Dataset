`timescale 1ns/1ps

module nvme_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cmd;
    reg rst;
    reg start;
    wire done;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nvme_controller dut (
        .clk(clk),
        .cmd(cmd),
        .rst(rst),
        .start(start),
        .done(done),
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
        cmd = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("\nRunning testcase001: Reset and Initial State");
        test_num = test_num + 1;
        reset_dut();

        #1;


        check_outputs(1'b0, 2'b00);
    end
        endtask

    task testcase002;

    begin
        $display("\nRunning testcase002: Read Command Transition");
        test_num = test_num + 1;
        reset_dut();


        start = 1;
        cmd = 0;
        @(posedge clk);
        #1 start = 0;


        @(posedge clk);

        @(posedge clk);


        #1;



        check_outputs(1'b1, 2'b00);
    end
        endtask

    task testcase003;

    begin
        $display("\nRunning testcase003: Write Command Transition");
        test_num = test_num + 1;
        reset_dut();


        start = 1;
        cmd = 1;
        @(posedge clk);
        #1 start = 0;


        @(posedge clk);

        @(posedge clk);

        #1;


        check_outputs(1'b1, 2'b00);
    end
        endtask

    task testcase004;

    begin
        $display("\nRunning testcase004: No Start Signal");
        test_num = test_num + 1;
        reset_dut();

        start = 0;
        cmd = 1;
        repeat(3) @(posedge clk);


        #1;



        check_outputs(1'b0, 2'b00);
    end
        endtask

    task testcase005;

    begin
        $display("\nRunning testcase005: Consecutive Read and Write");
        test_num = test_num + 1;
        reset_dut();


        start = 1; cmd = 0;
        @(posedge clk);
        #1 start = 0;
        repeat(2) @(posedge clk);


        #1 start = 1; cmd = 1;
        @(posedge clk);
        #1 start = 0;
        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b1, 2'b00);
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
        input expected_done;
        input [1:0] expected_state;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: done=%b, state=%h",
                         done, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, state=%h",
                         expected_done, expected_state);
                $display("  Got:      done=%b, state=%h",
                         done, state);
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
        $dumpvars(0,clk, cmd, rst, start, done, state);
    end

endmodule
