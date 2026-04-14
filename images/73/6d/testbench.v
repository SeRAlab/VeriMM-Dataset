`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] access_size;
    reg [31:0] addr;
    reg clk;
    reg [31:0] din;
    reg enable;
    reg rw;
    wire busy;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .access_size(access_size),
        .addr(addr),
        .clk(clk),
        .din(din),
        .enable(enable),
        .rw(rw),
        .busy(busy),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        access_size = 0;
        addr = 0;
        din = 0;
        enable = 0;
        rw = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Running Testcase 001: Word Access...");


        @(negedge clk);
        addr = 32'h00000000; din = 32'hDEADBEEF; access_size = 2'b10; rw = 1; enable = 1;
        @(negedge clk);
        enable = 0;
        @(posedge clk);
        while(busy) @(posedge clk);


        @(negedge clk);
        addr = 32'h00000000; access_size = 2'b10; rw = 0; enable = 1;
        @(negedge clk);
        enable = 0;
        @(posedge clk);
        while(busy) @(posedge clk);

        #1;


        check_outputs(1'b0, 32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Running Testcase 002: Halfword Access...");


        @(negedge clk);
        addr = 32'h00000004; din = 32'h0000ABCD; access_size = 2'b01; rw = 1; enable = 1;
        @(negedge clk);
        enable = 0;
        @(posedge clk);
        while(busy) @(posedge clk);


        @(negedge clk);
        addr = 32'h00000004; access_size = 2'b01; rw = 0; enable = 1;
        @(negedge clk);
        enable = 0;
        @(posedge clk);
        while(busy) @(posedge clk);

        #1;


        check_outputs(1'b0, 32'h0000ABCD);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Running Testcase 003: Byte Access...");


        @(negedge clk);
        addr = 32'h00000008; din = 32'h00000055; access_size = 2'b00; rw = 1; enable = 1;
        @(negedge clk);
        enable = 0;
        @(posedge clk);
        while(busy) @(posedge clk);


        @(negedge clk);
        addr = 32'h00000008; access_size = 2'b00; rw = 0; enable = 1;
        @(negedge clk);
        enable = 0;
        @(posedge clk);
        while(busy) @(posedge clk);

        #1;


        check_outputs(1'b0, 32'h00000055);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Running Testcase 004: Verify non-interference...");


        @(negedge clk);
        addr = 32'h10; din = 32'h11111111; access_size = 2'b10; rw = 1; enable = 1;
        @(negedge clk);
        enable = 0;
        @(posedge clk);
        while(busy) @(posedge clk);


        @(negedge clk);
        addr = 32'h14; din = 32'h22222222; access_size = 2'b10; rw = 1; enable = 1;
        @(negedge clk);
        enable = 0;
        @(posedge clk);
        while(busy) @(posedge clk);


        @(negedge clk);
        addr = 32'h10; access_size = 2'b10; rw = 0; enable = 1;
        @(negedge clk);
        enable = 0;
        @(posedge clk);
        while(busy) @(posedge clk);

        #1;


        check_outputs(1'b0, 32'h11111111);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Running Testcase 005: Write Word then Read same address...");


        @(negedge clk);
        addr = 32'h20; din = 32'h12345678; access_size = 2'b10; rw = 1; enable = 1;
        @(negedge clk);
        enable = 0;
        @(posedge clk);
        while(busy) @(posedge clk);


        @(negedge clk);
        addr = 32'h20; access_size = 2'b10; rw = 0; enable = 1;
        @(negedge clk);
        enable = 0;
        @(posedge clk);
        while(busy) @(posedge clk);

        #1;


        check_outputs(1'b0, 32'h12345678);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_busy;
        input [31:0] expected_dout;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, dout=%h",
                         busy, dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, dout=%h",
                         expected_busy, expected_dout);
                $display("  Got:      busy=%b, dout=%h",
                         busy, dout);
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
        $dumpvars(0,access_size, addr, clk, din, enable, rw, busy, dout);
    end

endmodule
