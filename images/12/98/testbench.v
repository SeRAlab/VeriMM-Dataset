`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req0;
    reg req1;
    reg req2;
    reg req3;
    reg rst;
    reg start;
    wire [1:0] current_channel;

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
        .start(start),
        .current_channel(current_channel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        start = 0;
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
        $display("\nTestcase %0d: Single request on Channel 0", test_num);
        reset_dut();
        @(negedge clk);
        start = 1;
        req0 = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Single request on Channel 2", test_num);
        reset_dut();
        @(negedge clk);
        start = 1;
        req2 = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Round-robin arbitration 0 then 1", test_num);
        reset_dut();
        @(negedge clk);
        start = 1;
        req0 = 1;
        req1 = 1;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Round-robin skipping channels (0 to 3)", test_num);
        reset_dut();
        @(negedge clk);
        start = 1;
        req0 = 1;
        req3 = 1;
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Round-robin wrap-around (3 back to 0)", test_num);
        reset_dut();
        @(negedge clk);
        start = 1;
        req0 = 1;
        req1 = 1;
        req2 = 1;
        req3 = 1;
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        #2;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Controller disabled (start=0)", test_num);
        reset_dut();
        @(negedge clk);
        start = 0;
        req1 = 1;
        @(posedge clk);
        @(posedge clk);
        #2;

        #1;


        check_outputs(2'b00);
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
        input [1:0] expected_current_channel;
        begin
            if (expected_current_channel === (expected_current_channel ^ current_channel ^ expected_current_channel)) begin
                $display("PASS");
                $display("  Outputs: current_channel=%h",
                         current_channel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_channel=%h",
                         expected_current_channel);
                $display("  Got:      current_channel=%h",
                         current_channel);
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
        $dumpvars(0,clk, req0, req1, req2, req3, rst, start, current_channel);
    end

endmodule
