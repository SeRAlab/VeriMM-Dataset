`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start;
    reg transfer_done;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .transfer_done(transfer_done),
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
            transfer_done = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Normal operation Idle -> Transfer -> Complete", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1 start = 0;


            transfer_done = 1;
            @(posedge clk);
            #1 transfer_done = 0;

            #1;


            check_outputs(STATE_COMPLETE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Return to Idle from Complete state via reset", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1 start = 0;
            transfer_done = 1;
            @(posedge clk);
            #1 transfer_done = 0;


            reset = 1;
            @(posedge clk);
            #1 reset = 0;

            #1;


            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stay in Idle state when no start signal", test_num);
            reset_dut();

            repeat(3) @(posedge clk);

            #1;


            check_outputs(STATE_IDLE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stay in Transfer state while transfer is in progress", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1 start = 0;


            repeat(5) @(posedge clk);


            #1;



            check_outputs(STATE_TRANSFER);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Emergency reset during Transfer state", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1 start = 0;


            reset = 1;
            @(posedge clk);
            #1 reset = 0;

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
        $display("sata_controller Testbench");
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
        $dumpvars(0,clk, reset, start, transfer_done, state);
    end

endmodule
