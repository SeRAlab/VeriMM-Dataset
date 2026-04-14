`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg done;
    reg reset;
    reg start;
    wire [1:0] state;
    wire transfer_in_progress;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .clk(clk),
        .done(done),
        .reset(reset),
        .start(start),
        .state(state),
        .transfer_in_progress(transfer_in_progress)
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
            done = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Initial Reset to IDLE", test_num);
            reset_dut();

            #1 #1;
 check_outputs(IDLE, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: IDLE to TRANSFER transition", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;

            #1;


            check_outputs(TRANSFER, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: TRANSFER to DONE transition", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;

            done = 1;
            @(posedge clk);
            #1 done = 0;

            #1;


            check_outputs(DONE, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Stay in TRANSFER while done is 0", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;
            done = 0;
            repeat(3) @(posedge clk);

            #1 #1;
 check_outputs(TRANSFER, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: DONE to IDLE return", test_num);
            reset_dut();

            start = 1; @(posedge clk);
            #1 start = 0; done = 1; @(posedge clk);
            #1 done = 0;

            @(posedge clk);
            #1 #1;
 check_outputs(IDLE, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Asynchronous/Synchronous Reset during TRANSFER", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;
            reset = 1;
            @(posedge clk);
            #1 reset = 0;

            #1;


            check_outputs(IDLE, 1'b0);
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
        input expected_transfer_in_progress;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state) &&
                expected_transfer_in_progress === (expected_transfer_in_progress ^ transfer_in_progress ^ expected_transfer_in_progress)) begin
                $display("PASS");
                $display("  Outputs: state=%h, transfer_in_progress=%b",
                         state, transfer_in_progress);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h, transfer_in_progress=%b",
                         expected_state, expected_transfer_in_progress);
                $display("  Got:      state=%h, transfer_in_progress=%b",
                         state, transfer_in_progress);
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
        $dumpvars(0,clk, done, reset, start, state, transfer_in_progress);
    end

endmodule
