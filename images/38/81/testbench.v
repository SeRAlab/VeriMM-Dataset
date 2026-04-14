`timescale 1ns/1ps

module pcie_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req_ready;
    reg req_valid;
    reg reset;
    reg resp_done;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_controller dut (
        .clk(clk),
        .req_ready(req_ready),
        .req_valid(req_valid),
        .reset(reset),
        .resp_done(resp_done),
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
            reset = 1;
            start = 0;
            req_valid = 0;
            req_ready = 0;
            resp_done = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full Transition Loop", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1 start = 0;
            req_valid = 1;


            @(posedge clk);
            #1 req_ready = 1;


            @(posedge clk);
            #1 req_ready = 0;
            resp_done = 1;

            @(posedge clk);
            #1 resp_done = 0;

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Hold in REQUEST State", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;
            req_valid = 1;
            req_ready = 0;

            repeat(3) @(posedge clk);

            #1;


            check_outputs(REQUEST);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Hold in RESPONSE State", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;
            req_valid = 1;
            req_ready = 1;

            @(posedge clk);
            #1 req_ready = 0;
            resp_done = 0;

            repeat(3) @(posedge clk);

            #1;


            check_outputs(RESPONSE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset while in REQUEST", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;


            reset = 1;
            @(posedge clk);
            #1 reset = 0;

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequence Completion and Restart", test_num);
            reset_dut();


            start = 1; @(posedge clk); #1 start = 0; req_ready = 1;
            @(posedge clk); #1 req_ready = 0; resp_done = 1;
            @(posedge clk); #1 resp_done = 0;


            start = 1;
            @(posedge clk);
            #1 start = 0;

            #1;


            check_outputs(REQUEST);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_controller Testbench");
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
        $dumpvars(0,clk, req_ready, req_valid, reset, resp_done, start, state);
    end

endmodule
