`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg [7:0] dest_addr;
    reg rst;
    reg [7:0] src_addr;
    reg start;
    wire [15:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .dest_addr(dest_addr),
        .rst(rst),
        .src_addr(src_addr),
        .start(start),
        .data_out(data_out),
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
            src_addr = 8'h0;
            dest_addr = 8'h0;
            data_in = 16'h0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Data Transfer", test_num);
            reset_dut();

            src_addr = 8'h0A;
            dest_addr = 8'h0B;
            data_in = 16'hABCD;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            while (!done) @(posedge clk);


            #1;



            check_outputs(16'hABCD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Maximum Address and Data Values", test_num);
            reset_dut();

            src_addr = 8'hFF;
            dest_addr = 8'hFE;
            data_in = 16'hFFFF;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Zero Data Transfer", test_num);
            reset_dut();

            src_addr = 8'h11;
            dest_addr = 8'h22;
            data_in = 16'h0000;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Alternating Bit Pattern", test_num);
            reset_dut();

            src_addr = 8'h55;
            dest_addr = 8'hAA;
            data_in = 16'h55AA;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(16'h55AA, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Post-Reset Operation", test_num);


            rst = 1;
            start = 1;
            data_in = 16'hDEAD;
            repeat(2) @(posedge clk);

            reset_dut();

            src_addr = 8'h12;
            dest_addr = 8'h34;
            data_in = 16'hBEEF;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            while (!done) @(posedge clk);

            #1;


            check_outputs(16'hBEEF, 1'b1);
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
        input [15:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,clk, data_in, dest_addr, rst, src_addr, start, data_out, done);
    end

endmodule
