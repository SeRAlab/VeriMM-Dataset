`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg enable;
    reg reset;
    wire [2:0] selected_channel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .selected_channel(selected_channel)
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
        channel_select = 3'b000;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying reset state", test_num);
        reset_dut();

        #1;


        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Selecting Channel 3 (Enable=1)", test_num);
        reset_dut();
        channel_select = 3'd3;
        enable = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Selecting Channel 7 (Enable=1)", test_num);
        reset_dut();
        channel_select = 3'd7;
        enable = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Selecting Channel 0 (Enable=1)", test_num);
        reset_dut();

        channel_select = 3'd5;
        enable = 1;
        @(posedge clk);

        channel_select = 3'd0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Changing Channel Select while Enable is Low", test_num);
        reset_dut();

        channel_select = 3'd4;
        enable = 1;
        @(posedge clk);

        enable = 0;
        channel_select = 3'd2;
        @(posedge clk);
        #2;




        #1;





        check_outputs(3'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Multiple sequential channel switches", test_num);
        reset_dut();
        enable = 1;
        channel_select = 3'd1; @(posedge clk);
        channel_select = 3'd6; @(posedge clk);
        channel_select = 3'd2; @(posedge clk);
        #2;
        #1;

        check_outputs(3'd2);
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
        input [2:0] expected_selected_channel;
        begin
            if (expected_selected_channel === (expected_selected_channel ^ selected_channel ^ expected_selected_channel)) begin
                $display("PASS");
                $display("  Outputs: selected_channel=%h",
                         selected_channel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: selected_channel=%h",
                         expected_selected_channel);
                $display("  Got:      selected_channel=%h",
                         selected_channel);
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
        $dumpvars(0,channel_select, clk, enable, reset, selected_channel);
    end

endmodule
