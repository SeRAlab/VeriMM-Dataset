`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] req;
    reg rst;
    wire [3:0] ack;
    wire [1:0] active_channel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req(req),
        .rst(rst),
        .ack(ack),
        .active_channel(active_channel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req = 4'b0000;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Single Request Channel 0");
            reset_dut();
            req = 4'b0001;

            wait(ack[0] == 1);
            #1;

            check_outputs(4'b0001, 2'd0);
            req = 4'b0000;
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Single Request Channel 3");
            reset_dut();
            req = 4'b1000;
            wait(ack[3] == 1);
            #1;

            check_outputs(4'b1000, 2'd3);
            req = 4'b0000;
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Simultaneous Requests Ch 1 and Ch 2");
            reset_dut();
            req = 4'b0110;

            wait(ack != 4'b0000);
            if (ack[1])
                #1;

                check_outputs(4'b0010, 2'd1);
            else if (ack[2])
                #1;

                check_outputs(4'b0100, 2'd2);


            req = req & ~ack;
            wait(ack != 0);
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Order of Arrival (Ch 3 then Ch 0)");
            reset_dut();
            req = 4'b1000;
            @(posedge clk);
            req = 4'b1001;


            wait(ack[3] == 1);
            #1;

            check_outputs(4'b1000, 2'd3);


            req = 4'b0001;
            wait(ack[0] == 1);
            #1;

            check_outputs(4'b0001, 2'd0);
            req = 4'b0000;
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Reset during operation");
            reset_dut();
            req = 4'b0100;
            @(posedge clk);
            #2 rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);

            #1;


            check_outputs(4'b0000, active_channel);
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
        input [3:0] expected_ack;
        input [1:0] expected_active_channel;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel)) begin
                $display("PASS");
                $display("  Outputs: ack=%h, active_channel=%h",
                         ack, active_channel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%h, active_channel=%h",
                         expected_ack, expected_active_channel);
                $display("  Got:      ack=%h, active_channel=%h",
                         ack, active_channel);
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
        $dumpvars(0,clk, req, rst, ack, active_channel);
    end

endmodule
