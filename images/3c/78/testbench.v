`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req0;
    reg req1;
    reg reset;
    wire ack0;
    wire ack1;
    wire [1:0] current_channel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req0(req0),
        .req1(req1),
        .reset(reset),
        .ack0(ack0),
        .ack1(ack1),
        .current_channel(current_channel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req0 = 0;
            req1 = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle State after Reset", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Channel 0 Single Request", test_num);
            reset_dut();
            req0 = 1;
            req1 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Channel 1 Single Request", test_num);
            reset_dut();
            req0 = 0;
            req1 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Requests (Priority Check)", test_num);
            reset_dut();
            req0 = 1;
            req1 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Channel Switching", test_num);
            reset_dut();


            req0 = 1;
            req1 = 1;
            @(posedge clk);
            #1;


            req0 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Requests Deasserted", test_num);
            reset_dut();

            req1 = 1;
            @(posedge clk);
            #1;

            req1 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input expected_ack0;
        input expected_ack1;
        input [1:0] expected_current_channel;
        begin
            if (expected_ack0 === (expected_ack0 ^ ack0 ^ expected_ack0) &&
                expected_ack1 === (expected_ack1 ^ ack1 ^ expected_ack1) &&
                expected_current_channel === (expected_current_channel ^ current_channel ^ expected_current_channel)) begin
                $display("PASS");
                $display("  Outputs: ack0=%b, ack1=%b, current_channel=%h",
                         ack0, ack1, current_channel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack0=%b, ack1=%b, current_channel=%h",
                         expected_ack0, expected_ack1, expected_current_channel);
                $display("  Got:      ack0=%b, ack1=%b, current_channel=%h",
                         ack0, ack1, current_channel);
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
        $dumpvars(0,clk, req0, req1, reset, ack0, ack1, current_channel);
    end

endmodule
