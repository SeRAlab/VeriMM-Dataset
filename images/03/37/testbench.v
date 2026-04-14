`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg end_receive;
    reg end_send;
    reg reset;
    reg start_receive;
    reg start_send;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .end_receive(end_receive),
        .end_send(end_send),
        .reset(reset),
        .start_receive(start_receive),
        .start_send(start_send),
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
            start_send = 0;
            end_send = 0;
            start_receive = 0;
            end_receive = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            start_send = 1;
            @(posedge clk);
            #1 start_send = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(SEND);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            start_send = 1;
            @(posedge clk);
            #1 start_send = 0;
            @(posedge clk);

            #1 end_send = 1;
            @(posedge clk);
            #1 end_send = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(IDLE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            start_receive = 1;
            @(posedge clk);
            #1 start_receive = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(RECEIVE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            start_receive = 1;
            @(posedge clk);
            #1 start_receive = 0;
            @(posedge clk);

            #1 end_receive = 1;
            @(posedge clk);
            #1 end_receive = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(IDLE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            start_send = 1;
            @(posedge clk);
            #1 start_send = 0;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(SEND);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            start_receive = 1;
            @(posedge clk);
            #1 start_receive = 0;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(RECEIVE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            start_receive = 1;
            @(posedge clk);
            #1 start_receive = 0;
            @(posedge clk);
            #1 end_send = 1;
            @(posedge clk);
            #1 end_send = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(RECEIVE);
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
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, end_receive, end_send, reset, start_receive, start_send, state);
    end

endmodule
