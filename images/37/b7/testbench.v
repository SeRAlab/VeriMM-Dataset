`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] req;
    reg reset;
    reg start;
    wire busy;
    wire [1:0] channel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req(req),
        .reset(reset),
        .start(start),
        .busy(busy),
        .channel(channel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            req = 4'b0000;
            start = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Channel Request (Ch 0)", test_num);
            reset_dut();
            req = 4'b0001;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Channel Request (Ch 2)", test_num);
            reset_dut();
            req = 4'b0100;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Requests (Ch 1, 2, 3)", test_num);
            reset_dut();
            req = 4'b1110;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Round-Robin Sequence (0 then 1)", test_num);
            reset_dut();
            req = 4'b1111;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);




            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Round-Robin Wrap-around (3 then 0)", test_num);
            reset_dut();
            req = 4'b1001;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Start with no active requests", test_num);
            reset_dut();
            req = 4'b0000;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat(2) @(posedge clk);
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
        input [1:0] expected_channel;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_channel === (expected_channel ^ channel ^ expected_channel)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, channel=%h",
                         busy, channel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, channel=%h",
                         expected_busy, expected_channel);
                $display("  Got:      busy=%b, channel=%h",
                         busy, channel);
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
        $dumpvars(0,clk, req, reset, start, busy, channel);
    end

endmodule
