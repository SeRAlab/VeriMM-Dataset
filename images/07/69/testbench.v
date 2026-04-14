`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] dest_addr;
    reg rst_n;
    reg [7:0] src_addr;
    reg start;
    reg [3:0] transfer_size;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr(dest_addr),
        .rst_n(rst_n),
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
            rst_n = 1'b0;
            start = 1'b0;
            src_addr = 8'h00;
            dest_addr = 8'h00;
            transfer_size = 4'd0;
            #20;
            rst_n = 1'b1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimal Transfer (Size 1)", test_num);
            reset_dut();

            src_addr = 8'h10;
            dest_addr = 8'h20;
            transfer_size = 4'd1;
            start = 1'b1;

            @(posedge clk);
            #1 start = 1'b0;


            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Medium Transfer (Size 8)", test_num);
            reset_dut();

            src_addr = 8'hA0;
            dest_addr = 8'hB0;
            transfer_size = 4'd8;
            start = 1'b1;

            @(posedge clk);
            #1 start = 1'b0;


            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Transfer (Size 15)", test_num);
            reset_dut();

            src_addr = 8'h00;
            dest_addr = 8'hF0;
            transfer_size = 4'd15;
            start = 1'b1;

            @(posedge clk);
            #1 start = 1'b0;


            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Size Transfer", test_num);
            reset_dut();

            src_addr = 8'h05;
            dest_addr = 8'h0A;
            transfer_size = 4'd0;
            start = 1'b1;

            @(posedge clk);
            #1 start = 1'b0;


            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset after Transfer", test_num);
            reset_dut();

            src_addr = 8'h11;
            dest_addr = 8'h22;
            transfer_size = 4'd2;
            start = 1'b1;
            @(posedge clk);
            #1 start = 1'b0;

            wait(done === 1'b1);
            @(posedge clk);


            rst_n = 1'b0;
            #10;
            rst_n = 1'b1;
            @(posedge clk);

            if (done === 1'b0) begin
                $display("PASS: Done signal cleared on reset");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Done signal remained high after reset");
                fail_count = fail_count + 1;
            end
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
        $dumpvars(0,clk, dest_addr, rst_n, src_addr, start, transfer_size, done);
    end

endmodule
