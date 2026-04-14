`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg enable;
    wire [7:0] channel_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .enable(enable),
        .channel_output(channel_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        channel_select <= 3'b0;
        enable <= 1'b0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Channel 0, Enable=1", test_num);
        reset_dut();
        channel_select <= 3'd0;
        enable <= 1'b1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'b00000001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Channel 7, Enable=1", test_num);
        reset_dut();
        channel_select <= 3'd7;
        enable <= 1'b1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'b10000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Channel 3, Enable=1", test_num);
        reset_dut();
        channel_select <= 3'd3;
        enable <= 1'b1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'b00001000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Channel 4, Enable=0", test_num);
        reset_dut();
        channel_select <= 3'd4;
        enable <= 1'b0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Dynamic switching from Ch 2 to Ch 5", test_num);
        reset_dut();
        enable <= 1'b1;
        channel_select <= 3'd2;
        @(posedge clk);
        channel_select <= 3'd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'b00100000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Deassert Enable after activity", test_num);
        reset_dut();
        channel_select <= 3'd6;
        enable <= 1'b1;
        @(posedge clk);
        enable <= 1'b0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Select Channel 1, Enable=1", test_num);
        reset_dut();
        channel_select <= 3'd1;
        enable <= 1'b1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'b00000010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Final channel 4 check", test_num);
        reset_dut();
        channel_select <= 3'd4;
        enable <= 1'b1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'b00010000);
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
        input [7:0] expected_channel_output;
        begin
            if (expected_channel_output === (expected_channel_output ^ channel_output ^ expected_channel_output)) begin
                $display("PASS");
                $display("  Outputs: channel_output=%h",
                         channel_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channel_output=%h",
                         expected_channel_output);
                $display("  Got:      channel_output=%h",
                         channel_output);
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
        $dumpvars(0,channel_select, clk, enable, channel_output);
    end

endmodule
