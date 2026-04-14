`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] ack;
    reg [11:0] adr;
    reg clk;
    reg [15:0] data;
    reg rst;
    reg wr;
    wire [15:0] req;
    wire [15:0] val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ack(ack),
        .adr(adr),
        .clk(clk),
        .data(data),
        .rst(rst),
        .wr(wr),
        .req(req),
        .val(val)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            adr = 0;
            wr = 0;
            data = 0;
            ack = 0;
            repeat(2) @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: System Reset", test_num);
            reset_dut();
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Activate Task 0", test_num);
            reset_dut();
            adr = 12'h000;
            wr = 1;
            data = 16'h0001;
            @(posedge clk);
            #1;
            wr = 0;
            data = 0;
            #1;

            check_outputs(16'h0001, 16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Task Activation and Acknowledge", test_num);
            reset_dut();

            adr = 12'h000; wr = 1; data = 16'h0002;
            @(posedge clk); #1;
            wr = 0;

            ack = 16'h0002;
            @(posedge clk); #1;
            ack = 0;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Activate Multiple Tasks (All)", test_num);
            reset_dut();
            adr = 12'h000; wr = 1; data = 16'hFFFF;
            @(posedge clk); #1;
            wr = 0;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Partial Acknowledge", test_num);
            reset_dut();

            adr = 12'h000; wr = 1; data = 16'hFFFF;
            @(posedge clk); #1;
            wr = 0;

            ack = 16'h00FF;
            @(posedge clk); #1;
            ack = 0;
            #1;

            check_outputs(16'hFF00, 16'hFF00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Write to Wrong Address", test_num);
            reset_dut();
            adr = 12'hFFF;
            wr = 1;
            data = 16'h1234;
            @(posedge clk); #1;
            wr = 0;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Request Persistence", test_num);
            reset_dut();
            adr = 12'h000; wr = 1; data = 16'h00AA;
            @(posedge clk); #1;
            wr = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h00AA, 16'h00AA);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Ack during invalid address write", test_num);
            reset_dut();

            adr = 12'h000; wr = 1; data = 16'hF0F0;
            @(posedge clk); #1;

            adr = 12'hABC; wr = 1; data = 16'h000F;
            ack = 16'hF000;
            @(posedge clk); #1;
            wr = 0; ack = 0;
            #1;

            check_outputs(16'h00F0, 16'h00F0);
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
        input [15:0] expected_req;
        input [15:0] expected_val;
        begin
            if (expected_req === (expected_req ^ req ^ expected_req) &&
                expected_val === (expected_val ^ val ^ expected_val)) begin
                $display("PASS");
                $display("  Outputs: req=%h, val=%h",
                         req, val);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: req=%h, val=%h",
                         expected_req, expected_val);
                $display("  Got:      req=%h, val=%h",
                         req, val);
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
        $dumpvars(0,ack, adr, clk, data, rst, wr, req, val);
    end

endmodule
