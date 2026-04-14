`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_select;
    reg clk;
    reg enable;
    reg reset;
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
        .reset(reset),
        .channel_output(channel_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            channel_select = 3'b000;
            enable = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Channel 0 (Enabled)", test_num);
            reset_dut();
            @(posedge clk);
            channel_select = 3'd0;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Channel 7 (Enabled)", test_num);
            reset_dut();
            @(posedge clk);
            channel_select = 3'd7;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Channel 3 (Disabled)", test_num);
            reset_dut();
            @(posedge clk);
            channel_select = 3'd3;
            enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Channel 4 (Enabled)", test_num);
            reset_dut();
            @(posedge clk);
            channel_select = 3'd4;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Switch Channel 1 to 5 (Enabled)", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            channel_select = 3'd1;
            @(posedge clk);
            channel_select = 3'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disable after activity", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            channel_select = 3'd2;
            @(posedge clk);
            enable = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
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
        $dumpvars(0,channel_select, clk, enable, reset, channel_output);
    end

endmodule
