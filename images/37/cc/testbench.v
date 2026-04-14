`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] request;
    reg rst;
    wire [1:0] active_channel;
    wire transfer_active;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .request(request),
        .rst(rst),
        .active_channel(active_channel),
        .transfer_active(transfer_active)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            request = 4'b0000;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Channel 0 Request", test_num);
            reset_dut();
            request = 4'b0001;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(2'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Channel 1 Request", test_num);
            reset_dut();
            request = 4'b0010;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(2'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Channel 2 Request", test_num);
            reset_dut();
            request = 4'b0100;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(2'd2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Channel 3 Request", test_num);
            reset_dut();
            request = 4'b1000;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(2'd3, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Requests (0 and 2)", test_num);
            reset_dut();
            request = 4'b0101;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(2'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Requests (1 and 3)", test_num);
            reset_dut();
            request = 4'b1010;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(2'd1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All Channels Requesting", test_num);
            reset_dut();
            request = 4'b1111;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(2'd0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Request then De-assert", test_num);
            reset_dut();
            request = 4'b0010;
            @(posedge clk);
            request = 4'b0000;
            repeat(2) @(posedge clk);
            #2;

            #1;


            check_outputs(2'b00, 1'b0);
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
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [1:0] expected_active_channel;
        input expected_transfer_active;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_transfer_active === (expected_transfer_active ^ transfer_active ^ expected_transfer_active)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h, transfer_active=%b",
                         active_channel, transfer_active);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h, transfer_active=%b",
                         expected_active_channel, expected_transfer_active);
                $display("  Got:      active_channel=%h, transfer_active=%b",
                         active_channel, transfer_active);
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
        $dumpvars(0,clk, request, rst, active_channel, transfer_active);
    end

endmodule
