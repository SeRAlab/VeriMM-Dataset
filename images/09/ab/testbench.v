`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr_channel1;
    reg [7:0] addr_channel2;
    reg clk;
    reg rst;
    reg [7:0] size_channel1;
    reg [7:0] size_channel2;
    reg start_channel1;
    reg start_channel2;
    wire done_channel1;
    wire done_channel2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .addr_channel1(addr_channel1),
        .addr_channel2(addr_channel2),
        .clk(clk),
        .rst(rst),
        .size_channel1(size_channel1),
        .size_channel2(size_channel2),
        .start_channel1(start_channel1),
        .start_channel2(start_channel2),
        .done_channel1(done_channel1),
        .done_channel2(done_channel2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr_channel1 = 8'h00;
            addr_channel2 = 8'h00;
            size_channel1 = 8'h00;
            size_channel2 = 8'h00;
            start_channel1 = 0;
            start_channel2 = 0;
            repeat(2) @(posedge clk);
            #2 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Channel 1 basic transfer (size 5)", test_num);
            reset_dut();

            addr_channel1 = 8'h10;
            size_channel1 = 8'd5;
            @(posedge clk);
            start_channel1 = 1;
            @(posedge clk);
            start_channel1 = 0;


            wait(done_channel1 == 1);
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Channel 2 basic transfer (size 8)", test_num);
            reset_dut();

            addr_channel2 = 8'h20;
            size_channel2 = 8'd8;
            @(posedge clk);
            start_channel2 = 1;
            @(posedge clk);
            start_channel2 = 0;

            wait(done_channel2 == 1);
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous dual channel transfer", test_num);
            reset_dut();

            addr_channel1 = 8'h30;
            size_channel1 = 8'd4;
            addr_channel2 = 8'h40;
            size_channel2 = 8'd6;

            @(posedge clk);
            start_channel1 = 1;
            start_channel2 = 1;
            @(posedge clk);
            start_channel1 = 0;
            start_channel2 = 0;


            wait(done_channel1 == 1 && done_channel2 == 1);
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum transfer size (1 cycle)", test_num);
            reset_dut();

            addr_channel1 = 8'hAA;
            size_channel1 = 8'd1;
            @(posedge clk);
            start_channel1 = 1;
            @(posedge clk);
            start_channel1 = 0;

            wait(done_channel1 == 1);
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential transfers (Ch1 then Ch2)", test_num);
            reset_dut();


            addr_channel1 = 8'h50;
            size_channel1 = 8'd3;
            @(posedge clk);
            start_channel1 = 1;
            @(posedge clk);
            start_channel1 = 0;
            wait(done_channel1 == 1);


            addr_channel2 = 8'h60;
            size_channel2 = 8'd3;
            @(posedge clk);
            start_channel2 = 1;
            @(posedge clk);
            start_channel2 = 0;
            wait(done_channel2 == 1);

            repeat(1) @(posedge clk);


            #1;



            check_outputs(done_channel1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Staggered starts", test_num);
            reset_dut();

            addr_channel1 = 8'h70;
            size_channel1 = 8'd10;
            addr_channel2 = 8'h80;
            size_channel2 = 8'd2;

            @(posedge clk);
            start_channel1 = 1;
            repeat(3) @(posedge clk);
            start_channel1 = 0;
            start_channel2 = 1;
            @(posedge clk);
            start_channel2 = 0;

            wait(done_channel1 == 1 && done_channel2 == 1);
            repeat(1) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
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
        input expected_done_channel1;
        input expected_done_channel2;
        begin
            if (expected_done_channel1 === (expected_done_channel1 ^ done_channel1 ^ expected_done_channel1) &&
                expected_done_channel2 === (expected_done_channel2 ^ done_channel2 ^ expected_done_channel2)) begin
                $display("PASS");
                $display("  Outputs: done_channel1=%b, done_channel2=%b",
                         done_channel1, done_channel2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done_channel1=%b, done_channel2=%b",
                         expected_done_channel1, expected_done_channel2);
                $display("  Got:      done_channel1=%b, done_channel2=%b",
                         done_channel1, done_channel2);
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
        $dumpvars(0,addr_channel1, addr_channel2, clk, rst, size_channel1, size_channel2, start_channel1, start_channel2, done_channel1, done_channel2);
    end

endmodule
