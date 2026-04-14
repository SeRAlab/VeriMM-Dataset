`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg rst;
    wire [7:0] channel_enable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .rst(rst),
        .channel_enable(channel_enable)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            channel_select = 3'b000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            channel_select = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            channel_select = 3'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b00000010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            channel_select = 3'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b00000100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            channel_select = 3'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b00001000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            channel_select = 3'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b00010000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            channel_select = 3'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b00100000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            channel_select = 3'd6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b01000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            channel_select = 3'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b10000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();

            channel_select = 3'd3;
            @(posedge clk);
            #1;

            rst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'b00000000);
            rst = 0;
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
        input [7:0] expected_channel_enable;
        begin
            if (expected_channel_enable === (expected_channel_enable ^ channel_enable ^ expected_channel_enable)) begin
                $display("PASS");
                $display("  Outputs: channel_enable=%h",
                         channel_enable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channel_enable=%h",
                         expected_channel_enable);
                $display("  Got:      channel_enable=%h",
                         channel_enable);
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
        $dumpvars(0,channel_select, clk, rst, channel_enable);
    end

endmodule
