`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr_ch1;
    reg [7:0] dest_addr_ch2;
    reg reset;
    reg [7:0] src_addr_ch1;
    reg [7:0] src_addr_ch2;
    reg start_ch1;
    reg start_ch2;
    wire done_ch1;
    wire done_ch2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr_ch1(dest_addr_ch1),
        .dest_addr_ch2(dest_addr_ch2),
        .reset(reset),
        .src_addr_ch1(src_addr_ch1),
        .src_addr_ch2(src_addr_ch2),
        .start_ch1(start_ch1),
        .start_ch2(start_ch2),
        .done_ch1(done_ch1),
        .done_ch2(done_ch2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_ch1 = 0;
            start_ch2 = 0;
            src_addr_ch1 = 0;
            dest_addr_ch1 = 0;
            src_addr_ch2 = 0;
            dest_addr_ch2 = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 1 Independent Transfer", test_num);
            reset_dut();

            src_addr_ch1 = 8'h10;
            dest_addr_ch1 = 8'h20;

            @(posedge clk);
            start_ch1 = 1;
            @(posedge clk);
            start_ch1 = 0;


            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 2 Independent Transfer", test_num);
            reset_dut();

            src_addr_ch2 = 8'hA0;
            dest_addr_ch2 = 8'hB0;

            @(posedge clk);
            start_ch2 = 1;
            @(posedge clk);
            start_ch2 = 0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simultaneous Transfer", test_num);
            reset_dut();

            src_addr_ch1 = 8'h11;
            dest_addr_ch1 = 8'h22;
            src_addr_ch2 = 8'hAA;
            dest_addr_ch2 = 8'hBB;

            @(posedge clk);
            start_ch1 = 1;
            start_ch2 = 1;
            @(posedge clk);
            start_ch1 = 0;
            start_ch2 = 0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Idle State (No Start)", test_num);
            reset_dut();

            src_addr_ch1 = 8'h01;
            dest_addr_ch1 = 8'h02;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Transfer", test_num);
            reset_dut();


            src_addr_ch1 = 8'h30;
            dest_addr_ch1 = 8'h40;
            @(posedge clk);
            start_ch1 = 1;
            @(posedge clk);
            start_ch1 = 0;
            repeat(5) @(posedge clk);


            src_addr_ch2 = 8'hC0;
            dest_addr_ch2 = 8'hD0;
            @(posedge clk);
            start_ch2 = 1;
            @(posedge clk);
            start_ch2 = 0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Mid-Transfer", test_num);
            reset_dut();

            start_ch1 = 1;
            @(posedge clk);
            start_ch1 = 0;
            repeat(2) @(posedge clk);


            reset = 1;
            #20;
            reset = 0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_done_ch1;
        input expected_done_ch2;
        begin
            if (expected_done_ch1 === (expected_done_ch1 ^ done_ch1 ^ expected_done_ch1) &&
                expected_done_ch2 === (expected_done_ch2 ^ done_ch2 ^ expected_done_ch2)) begin
                $display("PASS");
                $display("  Outputs: done_ch1=%b, done_ch2=%b",
                         done_ch1, done_ch2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done_ch1=%b, done_ch2=%b",
                         expected_done_ch1, expected_done_ch2);
                $display("  Got:      done_ch1=%b, done_ch2=%b",
                         done_ch1, done_ch2);
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
        $dumpvars(0,clk, dest_addr_ch1, dest_addr_ch2, reset, src_addr_ch1, src_addr_ch2, start_ch1, start_ch2, done_ch1, done_ch2);
    end

endmodule
