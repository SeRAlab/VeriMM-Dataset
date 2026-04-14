`timescale 1ns/1ps

module DMA_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] req;
    reg rst;
    wire [3:0] ack;
    wire [7:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DMA_Controller dut (
        .clk(clk),
        .req(req),
        .rst(rst),
        .ack(ack),
        .data(data)
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
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Channel 0 Single Request", test_num);
            reset_dut();
            req = 4'b0001;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001, 8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Channel 3 Single Request", test_num);
            reset_dut();
            req = 4'b1000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000, 8'h08);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Test (Ch 1 vs Ch 2)", test_num);
            reset_dut();
            req = 4'b0110;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0010, 8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All-Channel Request (Priority Check)", test_num);
            reset_dut();
            req = 4'b1111;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001, 8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Idle State No Request", test_num);
            reset_dut();
            req = 4'b0000;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DMA_Controller Testbench");
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
        input [7:0] expected_data;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: ack=%h, data=%h",
                         ack, data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%h, data=%h",
                         expected_ack, expected_data);
                $display("  Got:      ack=%h, data=%h",
                         ack, data);
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
        $dumpvars(0,clk, req, rst, ack, data);
    end

endmodule
