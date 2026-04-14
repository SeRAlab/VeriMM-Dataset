`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] dest_addr;
    reg reset;
    reg [7:0] src_addr;
    reg start;
    wire [7:0] data_out;
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
        .reset(reset),
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
            reset = 1;
            start = 0;
            src_addr = 8'h0;
            dest_addr = 8'h0;
            data_in = 8'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Single Data Transfer", test_num);
            reset_dut();

            src_addr = 8'h0A;
            dest_addr = 8'h50;
            data_in = 8'hA5;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transfer 0xFF", test_num);
            reset_dut();

            src_addr = 8'hFF;
            dest_addr = 8'hEE;
            data_in = 8'hFF;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transfer 0x00", test_num);
            reset_dut();

            src_addr = 8'h11;
            dest_addr = 8'h22;
            data_in = 8'h00;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Consecutive Transfers", test_num);
            reset_dut();


            src_addr = 8'h01;
            dest_addr = 8'h02;
            data_in = 8'hD1;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            @(posedge clk);


            src_addr = 8'h03;
            dest_addr = 8'h04;
            data_in = 8'hD2;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            @(posedge clk);

            #1;


            check_outputs(8'hD2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();

            src_addr = 8'hAA;
            dest_addr = 8'hBB;
            data_in = 8'hCC;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            #2 reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, dest_addr, reset, src_addr, start, data_out, done);
    end

endmodule
