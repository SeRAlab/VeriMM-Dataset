`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_received;
    reg reset;
    reg start;
    reg transmit_complete;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .data_received(data_received),
        .reset(reset),
        .start(start),
        .transmit_complete(transmit_complete),
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
            data_received = 0;
            transmit_complete = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying IDLE state after Reset", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying IDLE -> READY transition", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            #1 start = 0;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying READY -> TRANSMITTING transition", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            #1 start = 0;
            data_received = 1;
            @(posedge clk);
            #1 data_received = 0;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying full cycle back to IDLE", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            #1 start = 0;
            data_received = 1;
            @(posedge clk);
            #1 data_received = 0;
            transmit_complete = 1;
            @(posedge clk);
            #1 transmit_complete = 0;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying state persistence in READY", test_num);
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            #1 start = 0;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verifying Reset while in TRANSMITTING state", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            #1 start = 0;
            data_received = 1;
            @(posedge clk);
            #1 data_received = 0;

            reset = 1;
            @(posedge clk);
            #1 reset = 0;

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
        $display("sata_controller Testbench");
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
        $dumpvars(0,clk, data_received, reset, start, transmit_complete, state);
    end

endmodule
