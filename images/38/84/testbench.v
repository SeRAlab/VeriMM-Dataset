`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr;
    reg [3:0] num_bytes;
    reg reset;
    reg [7:0] src_addr;
    reg start;
    wire busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .num_bytes(num_bytes),
        .reset(reset),
        .src_addr(src_addr),
        .start(start),
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
            start = 0;
            src_addr = 0;
            dest_addr = 0;
            num_bytes = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic 4-byte transfer", test_num);
            reset_dut();

            src_addr = 8'h10;
            dest_addr = 8'hA0;
            num_bytes = 4;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(6) @(posedge clk);


            #1;



            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single byte transfer", test_num);
            reset_dut();

            src_addr = 8'h20;
            dest_addr = 8'hB0;
            num_bytes = 1;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(3) @(posedge clk);

            #1;


            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum burst (15 bytes)", test_num);
            reset_dut();

            src_addr = 8'h00;
            dest_addr = 8'hF0;
            num_bytes = 15;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(20) @(posedge clk);

            #1;


            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset during operation", test_num);
            reset_dut();

            src_addr = 8'h44;
            dest_addr = 8'h55;
            num_bytes = 10;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(5) @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);


            #1;



            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transfer with 0 bytes (Edge case)", test_num);
            reset_dut();

            src_addr = 8'h05;
            dest_addr = 8'h06;
            num_bytes = 0;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat(2) @(posedge clk);

            #1;


            check_outputs(0);
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
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy)) begin
                $display("PASS");
                $display("  Outputs: busy=%b",
                         busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b",
                         expected_busy);
                $display("  Got:      busy=%b",
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
        $dumpvars(0,clk, dest_addr, num_bytes, reset, src_addr, start, busy);
    end

endmodule
