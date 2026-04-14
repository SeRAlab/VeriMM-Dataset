`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start_receive;
    reg start_transmit;
    wire [7:0] data_out;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .reset(reset),
        .start_receive(start_receive),
        .start_transmit(start_transmit),
        .data_out(data_out),
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
            start_receive = 0;
            start_transmit = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Power-on Reset to IDLE");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(8'h00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: IDLE to TRANSMIT transition");
            test_num = 2;
            reset_dut();
            start_transmit = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55, 2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: IDLE to RECEIVE transition");
            test_num = 3;
            reset_dut();
            start_receive = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hAA, 2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Return to IDLE from TRANSMIT");
            test_num = 4;
            reset_dut();

            start_transmit = 1;
            @(posedge clk);
            #1;

            start_transmit = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Return to IDLE from RECEIVE");
            test_num = 5;
            reset_dut();

            start_receive = 1;
            @(posedge clk);
            #1;

            start_receive = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Priority check (Both signals high)");
            test_num = 6;
            reset_dut();
            start_transmit = 1;
            start_receive = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55, 2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        input [7:0] expected_data_out;
        input [1:0] expected_state;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, state=%h",
                         data_out, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, state=%h",
                         expected_data_out, expected_state);
                $display("  Got:      data_out=%h, state=%h",
                         data_out, state);
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
        $dumpvars(0,clk, reset, start_receive, start_transmit, data_out, state);
    end

endmodule
