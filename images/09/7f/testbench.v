`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req0;
    reg req1;
    reg req2;
    reg req3;
    reg rst;
    wire [1:0] active_channel;
    wire grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req0(req0),
        .req1(req1),
        .req2(req2),
        .req3(req3),
        .rst(rst),
        .active_channel(active_channel),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            req0 = 0;
            req1 = 0;
            req2 = 0;
            req3 = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No requests active", test_num);
            reset_dut();
            req0 = 0; req1 = 0; req2 = 0; req3 = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Single request on Channel 0", test_num);
            reset_dut();
            req0 = 1; req1 = 0; req2 = 0; req3 = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Single request on Channel 1", test_num);
            reset_dut();
            req0 = 0; req1 = 1; req2 = 0; req3 = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Single request on Channel 2", test_num);
            reset_dut();
            req0 = 0; req1 = 0; req2 = 1; req3 = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Single request on Channel 3", test_num);
            reset_dut();
            req0 = 0; req1 = 0; req2 = 0; req3 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Multiple requests (0 and 3) - Priority check", test_num);
            reset_dut();
            req0 = 1; req1 = 0; req2 = 0; req3 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Multiple requests (1, 2, 3) - Priority check", test_num);
            reset_dut();
            req0 = 0; req1 = 1; req2 = 1; req3 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: All requests active - Priority check", test_num);
            reset_dut();
            req0 = 1; req1 = 1; req2 = 1; req3 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Requests 2 and 3 active - Priority check", test_num);
            reset_dut();
            req0 = 0; req1 = 0; req2 = 1; req3 = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'b10, 1'b1);
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
        input expected_grant;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h, grant=%b",
                         active_channel, grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h, grant=%b",
                         expected_active_channel, expected_grant);
                $display("  Got:      active_channel=%h, grant=%b",
                         active_channel, grant);
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
        $dumpvars(0,clk, req0, req1, req2, req3, rst, active_channel, grant);
    end

endmodule
