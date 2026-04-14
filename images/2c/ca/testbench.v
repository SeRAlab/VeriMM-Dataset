`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] enable;
    reg [7:0] request;
    reg rst;
    reg [7:0] transfer_size;
    wire [7:0] active_channel;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .enable(enable),
        .request(request),
        .rst(rst),
        .transfer_size(transfer_size),
        .active_channel(active_channel),
        .transfer_complete(transfer_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 8'h00;
            request = 8'h00;
            transfer_size = 8'h00;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Channel Transfer (Ch 0)", test_num);
            reset_dut();
            enable = 8'h01;
            request = 8'h01;
            transfer_size = 8'd4;

            repeat (10) @(posedge clk);
            #1;

            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Channel Transfer (Ch 4)", test_num);
            reset_dut();
            enable = 8'h10;
            request = 8'h10;
            transfer_size = 8'd2;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(8'h10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Disabled Channel Request", test_num);
            reset_dut();
            enable = 8'h00;
            request = 8'h01;
            transfer_size = 8'd5;
            repeat (10) @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Priority Service (Ch 1 vs Ch 7)", test_num);
            reset_dut();
            enable = 8'hFF;
            request = 8'h82;
            transfer_size = 8'd3;
            repeat (10) @(posedge clk);

            #1;


            check_outputs(8'h02, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Large Transfer Size", test_num);
            reset_dut();
            enable = 8'h04;
            request = 8'h04;
            transfer_size = 8'd50;
            repeat (60) @(posedge clk);
            #1;

            check_outputs(8'h04, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Idle State No Request", test_num);
            reset_dut();
            enable = 8'hFF;
            request = 8'h00;
            transfer_size = 8'h0A;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_active_channel;
        input expected_transfer_complete;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h, transfer_complete=%b",
                         active_channel, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h, transfer_complete=%b",
                         expected_active_channel, expected_transfer_complete);
                $display("  Got:      active_channel=%h, transfer_complete=%b",
                         active_channel, transfer_complete);
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
        $dumpvars(0,clk, enable, request, rst, transfer_size, active_channel, transfer_complete);
    end

endmodule
