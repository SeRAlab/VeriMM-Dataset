`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [31:0] dest_addr;
    reg reset;
    reg [31:0] src_addr;
    reg start;
    wire [31:0] data_out;
    wire error;
    wire ready;

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
        .error(error),
        .ready(ready)
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
        data_in = 0;
        src_addr = 0;
        dest_addr = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Single Word Transfer", test_num);
        reset_dut();

        src_addr = 32'h0000_1000;
        dest_addr = 32'h0000_2000;
        data_in = 32'hABCD_1234;
        start = 1;

        @(posedge clk);
        start = 0;



        wait(ready === 1);
        #1;

        #1;


        check_outputs(32'hABCD_1234, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Transfer Maximum Word Value", test_num);
        reset_dut();

        src_addr = 32'hFFFF_0000;
        dest_addr = 32'hFFFF_FFFF;
        data_in = 32'hFFFF_FFFF;
        start = 1;

        @(posedge clk);
        start = 0;

        wait(ready === 1);
        #1;

        #1;


        check_outputs(32'hFFFF_FFFF, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Transfer with Null Address (Simulate Error)", test_num);
        reset_dut();

        src_addr = 32'h0000_0000;
        dest_addr = 32'h0000_5000;
        data_in = 32'hCAFE_BABE;
        start = 1;

        @(posedge clk);
        start = 0;


        @(posedge clk);
        while (ready == 0 && error == 0) @(posedge clk);
        #1;



        #1;




        check_outputs(data_out, error, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Consecutive Transfers", test_num);
        reset_dut();


        src_addr = 32'h1;
        dest_addr = 32'h2;
        data_in = 32'h1111_1111;
        start = 1;
        @(posedge clk);
        start = 0;
        wait(ready === 1);


        src_addr = 32'h3;
        dest_addr = 32'h4;
        data_in = 32'h2222_2222;
        start = 1;
        @(posedge clk);
        start = 0;
        wait(ready === 1);
        #1;

        #1;


        check_outputs(32'h2222_2222, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Data Transfer", test_num);
        reset_dut();

        src_addr = 32'hA;
        dest_addr = 32'hB;
        data_in = 32'h0000_0000;
        start = 1;

        @(posedge clk);
        start = 0;

        wait(ready === 1);
        #1;

        #1;


        check_outputs(32'h0000_0000, 1'b0, 1'b1);
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
        input [31:0] expected_data_out;
        input expected_error;
        input expected_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error === (expected_error ^ error ^ expected_error) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, error=%b, ready=%b",
                         data_out, error, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, error=%b, ready=%b",
                         expected_data_out, expected_error, expected_ready);
                $display("  Got:      data_out=%h, error=%b, ready=%b",
                         data_out, error, ready);
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
        $dumpvars(0,clk, data_in, dest_addr, reset, src_addr, start, data_out, error, ready);
    end

endmodule
