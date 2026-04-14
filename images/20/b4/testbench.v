`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg frame_valid;
    reg reset;
    reg start_receive;
    reg transmit;
    wire [1:0] current_state;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .frame_valid(frame_valid),
        .reset(reset),
        .start_receive(start_receive),
        .transmit(transmit),
        .current_state(current_state),
        .data_out(data_out)
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
            frame_valid = 0;
            transmit = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State Check");
            reset_dut();

            #1;


            check_outputs(IDLE, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: IDLE to RECEIVE Transition");
            reset_dut();
            start_receive = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(RECEIVE, 8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: RECEIVE to PROCESS Transition");
            reset_dut();

            start_receive = 1;
            @(posedge clk);
            #2 start_receive = 0;
            frame_valid = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(PROCESS, data_out);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: PROCESS to TRANSMIT Transition");
            reset_dut();

            start_receive = 1;
            @(posedge clk);
            #2 start_receive = 0;
            frame_valid = 1;

            @(posedge clk);
            #2 frame_valid = 0;
            transmit = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(TRANSMIT, 8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Full Cycle back to IDLE");
            reset_dut();

            start_receive = 1; @(posedge clk); #2 start_receive = 0;
            frame_valid = 1;   @(posedge clk); #2 frame_valid = 0;
            transmit = 1;      @(posedge clk); #2 transmit = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(IDLE, 8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Stay in IDLE if no start signal");
            reset_dut();
            frame_valid = 1;
            transmit = 1;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(IDLE, 8'h00);
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
        input [1:0] expected_current_state;
        input [7:0] expected_data_out;
        begin
            if (expected_current_state === (expected_current_state ^ current_state ^ expected_current_state) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: current_state=%h, data_out=%h",
                         current_state, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_state=%h, data_out=%h",
                         expected_current_state, expected_data_out);
                $display("  Got:      current_state=%h, data_out=%h",
                         current_state, data_out);
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
        $dumpvars(0,clk, frame_valid, reset, start_receive, transmit, current_state, data_out);
    end

endmodule
