`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_select;
    reg clk;
    reg reset;
    reg start;
    wire busy;
    wire [1:0] selected_channel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .clk(clk),
        .reset(reset),
        .start(start),
        .busy(busy),
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
            start = 0;
            channel_select = 2'b00;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Post-Reset Idle State", test_num);

            #1;


            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Select and Start Channel 0", test_num);
            channel_select = 2'b00;
            start = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Select and Start Channel 1", test_num);
            channel_select = 2'b01;
            start = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Select and Start Channel 2", test_num);
            channel_select = 2'b10;
            start = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Select and Start Channel 3", test_num);
            channel_select = 2'b11;
            start = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Change Channel without Start Assertion", test_num);
            channel_select = 2'b10;
            start = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during active transfer", test_num);
            channel_select = 2'b01;
            start = 1;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 2'b00);
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
        input [1:0] expected_selected_channel;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_selected_channel === (expected_selected_channel ^ selected_channel ^ expected_selected_channel)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, selected_channel=%h",
                         busy, selected_channel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, selected_channel=%h",
                         expected_busy, expected_selected_channel);
                $display("  Got:      busy=%b, selected_channel=%h",
                         busy, selected_channel);
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
        $dumpvars(0,channel_select, clk, reset, start, busy, selected_channel);
    end

endmodule
