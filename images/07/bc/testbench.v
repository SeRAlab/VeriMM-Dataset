`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] dst_addr;
    reg rst;
    reg [7:0] src_addr;
    reg start;
    wire complete;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .dst_addr(dst_addr),
        .rst(rst),
        .src_addr(src_addr),
        .start(start),
        .complete(complete),
        .data_out(data_out)
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
            src_addr = 8'h0;
            dst_addr = 8'h0;
            data_in = 8'h0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic Transfer (0xAA)", test_num);
            reset_dut();

            src_addr = 8'h10;
            dst_addr = 8'h20;
            data_in = 8'hAA;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(complete == 1'b1);
            #2;

            #1;


            check_outputs(1'b1, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Transfer with different data (0x55)", test_num);
            reset_dut();

            src_addr = 8'hA0;
            dst_addr = 8'hB0;
            data_in = 8'h55;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(complete == 1'b1);
            #2;

            #1;


            check_outputs(1'b1, 8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Boundary value transfer (0xFF)", test_num);
            reset_dut();

            src_addr = 8'h00;
            dst_addr = 8'hFF;
            data_in = 8'hFF;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(complete == 1'b1);
            #2;

            #1;


            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero data transfer (0x00)", test_num);
            reset_dut();

            src_addr = 8'h11;
            dst_addr = 8'h22;
            data_in = 8'h00;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(complete == 1'b1);
            #2;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset during operation", test_num);
            reset_dut();

            src_addr = 8'h05;
            dst_addr = 8'h06;
            data_in = 8'hCC;

            @(posedge clk);
            start = 1;
            repeat(1) @(posedge clk);


            rst = 1;
            #20;
            rst = 0;
            #10;


            #1;



            check_outputs(1'b0, 8'h00);
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
        input expected_complete;
        input [7:0] expected_data_out;
        begin
            if (expected_complete === (expected_complete ^ complete ^ expected_complete) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: complete=%b, data_out=%h",
                         complete, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: complete=%b, data_out=%h",
                         expected_complete, expected_data_out);
                $display("  Got:      complete=%b, data_out=%h",
                         complete, data_out);
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
        $dumpvars(0,clk, data_in, dst_addr, rst, src_addr, start, complete, data_out);
    end

endmodule
