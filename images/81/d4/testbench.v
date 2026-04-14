`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [7:0] framesize;
    reg in;
    reg reset;
    wire complete;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .framesize(framesize),
        .in(in),
        .reset(reset),
        .complete(complete),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            in = 0;
            framesize = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        integer i;
        reg [31:0] data;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 8-bit deserialization (Data: 0xA5)", test_num);
            reset_dut();

            data = 32'h000000A5;
            framesize = 8;

            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                enable = 1;
                in = data[i];
            end


            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 32'h000000A5);
        end
        endtask

    task testcase002;

        integer i;
        reg [31:0] data;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 4-bit deserialization (Data: 0x9)", test_num);
            reset_dut();

            data = 32'h00000009;
            framesize = 4;

            for (i = 0; i < 4; i = i + 1) begin
                @(negedge clk);
                enable = 1;
                in = data[i];
            end

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 32'h00000009);
        end
        endtask

    task testcase003;

        integer i;
        reg [31:0] data;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 32-bit deserialization (Data: 0xDEADBEEF)", test_num);
            reset_dut();

            data = 32'hDEADBEEF;
            framesize = 32;

            for (i = 0; i < 32; i = i + 1) begin
                @(negedge clk);
                enable = 1;
                in = data[i];
            end

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 32'hDEADBEEF);
        end
        endtask

    task testcase004;

        integer i;
        reg [31:0] data;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable signal behavior (Stalling)", test_num);
            reset_dut();

            data = 32'h0000000F;
            framesize = 4;


            for (i = 0; i < 2; i = i + 1) begin
                @(negedge clk);
                enable = 1;
                in = data[i];
            end


            @(negedge clk);
            enable = 0;
            in = 1'b0;
            @(negedge clk);
            enable = 0;
            in = 1'b0;


            for (i = 2; i < 4; i = i + 1) begin
                @(negedge clk);
                enable = 1;
                in = data[i];
            end

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 32'h0000000F);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset mid-operation", test_num);
            reset_dut();

            framesize = 8;


            for (i = 0; i < 4; i = i + 1) begin
                @(negedge clk);
                enable = 1;
                in = 1'b1;
            end


            @(negedge clk);
            reset = 1;
            @(negedge clk);
            reset = 0;


            #2;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Incomplete frame (Check complete stays low)", test_num);
            reset_dut();

            framesize = 10;


            for (i = 0; i < 5; i = i + 1) begin
                @(negedge clk);
                enable = 1;
                in = 1'b1;
            end

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 32'h0000001F);
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
        input expected_complete;
        input [31:0] expected_out;
        begin
            if (expected_complete === (expected_complete ^ complete ^ expected_complete) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: complete=%b, out=%h",
                         complete, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: complete=%b, out=%h",
                         expected_complete, expected_out);
                $display("  Got:      complete=%b, out=%h",
                         complete, out);
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
        $dumpvars(0,clk, enable, framesize, in, reset, complete, out);
    end

endmodule
