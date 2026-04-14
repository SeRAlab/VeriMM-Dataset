`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] dest_addr;
    reg rst;
    reg [15:0] src_addr;
    reg start;
    reg [7:0] transfer_size;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .rst(rst),
        .src_addr(src_addr),
        .start(start),
        .transfer_size(transfer_size),
        .done(done)
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
            src_addr = 0;
            dest_addr = 0;
            transfer_size = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Standard small transfer (size 10)...");
            reset_dut();
            test_num = test_num + 1;

            src_addr = 16'h1000;
            dest_addr = 16'h2000;
            transfer_size = 8'd10;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (transfer_size + 5) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Minimum transfer size (size 1)...");
            reset_dut();
            test_num = test_num + 1;

            src_addr = 16'h00A0;
            dest_addr = 16'h00B0;
            transfer_size = 8'd1;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            repeat (5) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Maximum transfer size (size 255)...");
            reset_dut();
            test_num = test_num + 1;

            src_addr = 16'h0000;
            dest_addr = 16'h8000;
            transfer_size = 8'd255;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (260) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Verify done stays low before start...");
            reset_dut();
            test_num = test_num + 1;

            src_addr = 16'h1234;
            dest_addr = 16'h5678;
            transfer_size = 8'd50;

            repeat (10) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Consecutive transfers...");
            reset_dut();
            test_num = test_num + 1;


            src_addr = 16'hAAAA;
            dest_addr = 16'hBBBB;
            transfer_size = 8'd5;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat (10) @(posedge clk);


            src_addr = 16'hCCCC;
            dest_addr = 16'hDDDD;
            transfer_size = 8'd2;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat (10) @(posedge clk);

            #1;


            check_outputs(1'b1);
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
        input expected_done;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: done=%b",
                         done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b",
                         expected_done);
                $display("  Got:      done=%b",
                         done);
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
        $dumpvars(0,clk, dest_addr, rst, src_addr, start, transfer_size, done);
    end

endmodule
