`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] req;
    reg reset;
    wire [3:0] ack;
    wire [1:0] ctrl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req(req),
        .reset(reset),
        .ack(ack),
        .ctrl(ctrl)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req = 4'b0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Single Request Channel 0");
            reset_dut();
            req = 4'b0001;
            @(posedge clk);
            #1;

            check_outputs(4'b0001, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Single Request Channel 3");
            reset_dut();
            req = 4'b1000;
            @(posedge clk);
            #1;

            check_outputs(4'b1000, 2'b11);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Simultaneous Requests (Ch1, Ch2)");
            reset_dut();
            req = 4'b0110;
            @(posedge clk);
            #1;

            check_outputs(4'b0100, 2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Hold Access (Non-Preemption)");
            reset_dut();
            req = 4'b0001;
            @(posedge clk);
            req = 4'b1001;
            @(posedge clk);

            #1;


            check_outputs(4'b0001, 2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Handover after Release");
            reset_dut();
            req = 4'b0010;
            @(posedge clk);
            req = 4'b0110;
            @(posedge clk);
            req = 4'b0100;
            @(posedge clk);
            #1;

            check_outputs(4'b0100, 2'b10);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: All Channels Requesting");
            reset_dut();
            req = 4'b1111;
            @(posedge clk);
            #1;

            check_outputs(4'b1000, 2'b11);
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
        input [3:0] expected_ack;
        input [1:0] expected_ctrl;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_ctrl === (expected_ctrl ^ ctrl ^ expected_ctrl)) begin
                $display("PASS");
                $display("  Outputs: ack=%h, ctrl=%h",
                         ack, ctrl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%h, ctrl=%h",
                         expected_ack, expected_ctrl);
                $display("  Got:      ack=%h, ctrl=%h",
                         ack, ctrl);
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
        $dumpvars(0,clk, req, reset, ack, ctrl);
    end

endmodule
