`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] req;
    wire [3:0] ack;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req(req),
        .ack(ack),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst_n = 0;
        req = 4'b0000;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Idle State Check");
        reset_dut();

        #2;
        #1;

        check_outputs(4'b0000, 8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Single Channel Request (Ch 0)");
        reset_dut();
        req = 4'b0001;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0001, 8'h00);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Single Channel Request (Ch 2)");
        reset_dut();
        req = 4'b0100;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0100, 8'h00);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Round Robin (Ch 0 then Ch 1)");
        reset_dut();
        req = 4'b0011;
        @(posedge clk);
        #1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b0010, 8'h00);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Full Round Robin Cycle");
        reset_dut();
        req = 4'b1111;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'b1000, 8'h00);
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
        input [7:0] expected_data_out;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ack=%h, data_out=%h",
                         ack, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%h, data_out=%h",
                         expected_ack, expected_data_out);
                $display("  Got:      ack=%h, data_out=%h",
                         ack, data_out);
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
        $dumpvars(0,clk, req, ack, data_out);
    end

endmodule
