`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] req;
    reg reset;
    wire [3:0] ack;
    wire [3:0] en;

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
        .en(en)
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
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Single Request Channel 0...");
        reset_dut();
        req = 4'b0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0001, 4'b0001);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Single Request Channel 3...");
        reset_dut();
        req = 4'b1000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1000, 4'b1000);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Mutual Exclusion (Ch 0 & Ch 1 active)...");
        reset_dut();
        req = 4'b0011;
        @(posedge clk);
        #1;

        #1;


        check_outputs(4'b0001, 4'b0001);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Round-Robin Transition...");
        reset_dut();
        req = 4'b0011;
        @(posedge clk);
        #1;
        req = 4'b0010;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0010, 4'b0010);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Full Sequence Round-Robin...");
        reset_dut();
        req = 4'b1111;
        @(posedge clk);
        #1; req = 4'b1110;
        @(posedge clk);
        #1; req = 4'b1100;
        @(posedge clk);
        #1; req = 4'b1000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1000, 4'b1000);
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
        input [3:0] expected_en;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_en === (expected_en ^ en ^ expected_en)) begin
                $display("PASS");
                $display("  Outputs: ack=%h, en=%h",
                         ack, en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%h, en=%h",
                         expected_ack, expected_en);
                $display("  Got:      ack=%h, en=%h",
                         ack, en);
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
        $dumpvars(0,clk, req, reset, ack, en);
    end

endmodule
