`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg req_channel0;
    reg req_channel1;
    reg rst_n;
    wire ack_channel0;
    wire ack_channel1;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .req_channel0(req_channel0),
        .req_channel1(req_channel1),
        .rst_n(rst_n),
        .ack_channel0(ack_channel0),
        .ack_channel1(ack_channel1),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            req_channel0 = 0;
            req_channel1 = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single request on Channel 0", test_num);
            reset_dut();
            @(posedge clk);
            #1 req_channel0 = 1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single request on Channel 1", test_num);
            reset_dut();
            @(posedge clk);
            #1 req_channel1 = 1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Simultaneous requests (Priority check)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            req_channel0 = 1;
            req_channel1 = 1;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Channel 0 completes, Channel 1 starts", test_num);
            reset_dut();


            @(posedge clk);
            #1 req_channel0 = 1;
            req_channel1 = 1;
            repeat(2) @(posedge clk);


            #1 req_channel0 = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All requests cleared, return to idle", test_num);
            reset_dut();

            @(posedge clk);
            #1 req_channel0 = 1;
            repeat(2) @(posedge clk);

            #1 req_channel0 = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset during operation", test_num);
            reset_dut();

            @(posedge clk);
            #1 req_channel0 = 1;
            repeat(1) @(posedge clk);


            #1 rst_n = 0;
            repeat(1) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 1'b1);
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
        input expected_ack_channel0;
        input expected_ack_channel1;
        input expected_ready;
        begin
            if (expected_ack_channel0 === (expected_ack_channel0 ^ ack_channel0 ^ expected_ack_channel0) &&
                expected_ack_channel1 === (expected_ack_channel1 ^ ack_channel1 ^ expected_ack_channel1) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: ack_channel0=%b, ack_channel1=%b, ready=%b",
                         ack_channel0, ack_channel1, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_channel0=%b, ack_channel1=%b, ready=%b",
                         expected_ack_channel0, expected_ack_channel1, expected_ready);
                $display("  Got:      ack_channel0=%b, ack_channel1=%b, ready=%b",
                         ack_channel0, ack_channel1, ready);
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
        $dumpvars(0,clk, req_channel0, req_channel1, rst_n, ack_channel0, ack_channel1, ready);
    end

endmodule
