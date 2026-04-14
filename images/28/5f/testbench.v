`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg channel_request;
    reg [2:0] channel_select;
    reg clk;
    reg reset;
    wire [7:0] busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_request(channel_request),
        .channel_select(channel_select),
        .clk(clk),
        .reset(reset),
        .busy(busy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            channel_request = 0;
            channel_select = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Toggle Channel 0 (0 -> 1)", test_num);
            reset_dut();
            channel_select = 3'd0;
            channel_request = 1;
            @(posedge clk);
            #1 channel_request = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Toggle Channel 7 (0 -> 1)", test_num);
            reset_dut();
            channel_select = 3'd7;
            channel_request = 1;
            @(posedge clk);
            #1 channel_request = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Double Toggle Channel 3 (0 -> 1 -> 0)", test_num);
            reset_dut();
            channel_select = 3'd3;
            channel_request = 1;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1;
            channel_request = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Channels (1 and 4)", test_num);
            reset_dut();


            channel_select = 3'd1;
            channel_request = 1;
            @(posedge clk);


            #1 channel_select = 3'd4;
            channel_request = 1;
            @(posedge clk);

            #1 channel_request = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Request Low (No Toggle)", test_num);
            reset_dut();
            channel_select = 3'd2;
            channel_request = 0;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset clearing active channels", test_num);
            reset_dut();


            channel_select = 3'd5;
            channel_request = 1;
            @(posedge clk);
            #1 channel_request = 0;


            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Toggle all 8 channels sequentially", test_num);
            reset_dut();
            for(i=0; i<8; i=i+1) begin
                channel_select = i;
                channel_request = 1;
                @(posedge clk);
                #1;
            end
            channel_request = 0;
            @(posedge clk);
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_busy;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy)) begin
                $display("PASS");
                $display("  Outputs: busy=%h",
                         busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%h",
                         expected_busy);
                $display("  Got:      busy=%h",
                         busy);
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
        $dumpvars(0,channel_request, channel_select, clk, reset, busy);
    end

endmodule
