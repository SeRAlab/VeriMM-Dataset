`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg frame_received;
    reg process_done;
    reg reset;
    reg start_receive;
    reg transmit_done;
    wire [1:0] current_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .frame_received(frame_received),
        .process_done(process_done),
        .reset(reset),
        .start_receive(start_receive),
        .transmit_done(transmit_done),
        .current_state(current_state)
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
            frame_received = 0;
            process_done = 0;
            transmit_done = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IDLE to RECEIVE", test_num);
            reset_dut();

            start_receive = 1;
            @(posedge clk);
            #1 start_receive = 0;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: RECEIVE to PROCESS", test_num);
            reset_dut();


            start_receive = 1;
            @(posedge clk);
            #1 start_receive = 0;


            frame_received = 1;
            @(posedge clk);
            #1 frame_received = 0;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: PROCESS to TRANSMIT", test_num);
            reset_dut();


            start_receive = 1; @(posedge clk); #1 start_receive = 0;

            frame_received = 1; @(posedge clk); #1 frame_received = 0;

            process_done = 1; @(posedge clk); #1 process_done = 0;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: TRANSMIT to IDLE (Full Cycle)", test_num);
            reset_dut();


            start_receive = 1; @(posedge clk); #1 start_receive = 0;
            frame_received = 1; @(posedge clk); #1 frame_received = 0;
            process_done = 1; @(posedge clk); #1 process_done = 0;
            transmit_done = 1; @(posedge clk); #1 transmit_done = 0;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset while in RECEIVE state", test_num);
            reset_dut();


            start_receive = 1;
            @(posedge clk);
            #1 start_receive = 0;


            reset = 1;
            @(posedge clk);
            #1 reset = 0;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stay in current state (PROCESS) without trigger", test_num);
            reset_dut();


            start_receive = 1; @(posedge clk); #1 start_receive = 0;
            frame_received = 1; @(posedge clk); #1 frame_received = 0;


            @(posedge clk);

            #1;


            check_outputs(2'b10);
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
        begin
            if (expected_current_state === (expected_current_state ^ current_state ^ expected_current_state)) begin
                $display("PASS");
                $display("  Outputs: current_state=%h",
                         current_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_state=%h",
                         expected_current_state);
                $display("  Got:      current_state=%h",
                         current_state);
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
        $dumpvars(0,clk, frame_received, process_done, reset, start_receive, transmit_done, current_state);
    end

endmodule
