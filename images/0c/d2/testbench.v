`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start_receive;
    reg start_transmit;
    wire [1:0] state;
    wire status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .reset(reset),
        .start_receive(start_receive),
        .start_transmit(start_transmit),
        .state(state),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_receive = 0;
            start_transmit = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(IDLE, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Transition IDLE to TRANSMIT", test_num);
            reset_dut();
            start_transmit = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(TRANSMIT, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Transition IDLE to RECEIVE", test_num);
            reset_dut();
            start_receive = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(RECEIVE, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: TRANSMIT to IDLE completion", test_num);
            reset_dut();

            start_transmit = 1;
            @(posedge clk);
            #1;

            start_transmit = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(IDLE, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: RECEIVE to IDLE completion", test_num);
            reset_dut();

            start_receive = 1;
            @(posedge clk);
            #1;

            start_receive = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(IDLE, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Concurrent Start (Priority Check)", test_num);
            reset_dut();
            start_transmit = 1;
            start_receive = 1;
            @(posedge clk);
            #1;

            if (state == TRANSMIT)
                #1;

                check_outputs(TRANSMIT, 1'b1);
            else if (state == RECEIVE)
                #1;

                check_outputs(RECEIVE, 1'b1);
            else
                #1;

                check_outputs(IDLE, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Maintain TRANSMIT state", test_num);
            reset_dut();
            start_transmit = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(TRANSMIT, 1'b1);
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
        input expected_status;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: state=%h, status=%b",
                         state, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h, status=%b",
                         expected_state, expected_status);
                $display("  Got:      state=%h, status=%b",
                         state, status);
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
        $dumpvars(0,clk, reset, start_receive, start_transmit, state, status);
    end

endmodule
