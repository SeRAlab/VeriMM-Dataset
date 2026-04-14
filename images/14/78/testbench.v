`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clk;
    reg [31:0] data_in;
    reg rst;
    reg rw;
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
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .rw(rw),
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
            rst = 1;
            start = 0;
            addr = 0;
            data_in = 0;
            rw = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset and Idle Check", test_num);
            reset_dut();


            #1;



            check_outputs(32'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write Operation", test_num);
            reset_dut();

            @(posedge clk);
            addr = 32'hA000_1234;
            data_in = 32'hDEAD_BEEF;
            rw = 1;
            start = 1;

            @(posedge clk);
            start = 0;



            repeat (5) @(posedge clk);



            #1;




            check_outputs(32'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Read Operation", test_num);
            reset_dut();

            @(posedge clk);
            addr = 32'hB000_5678;
            data_in = 32'hCAFE_BABE;
            rw = 0;
            start = 1;

            @(posedge clk);
            start = 0;


            repeat (5) @(posedge clk);


            #1;



            check_outputs(32'hCAFE_BABE, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Successive Transfers", test_num);
            reset_dut();


            @(posedge clk);
            addr = 32'h100;
            data_in = 32'h1111_1111;
            rw = 1;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(ready == 1);


            @(posedge clk);
            addr = 32'h200;
            data_in = 32'h2222_2222;
            rw = 0;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(ready == 1);


            @(posedge clk);
            addr = 32'h300;
            data_in = 32'h3333_3333;
            rw = 1;
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (2) @(posedge clk);
            while (!ready) @(posedge clk);


            #1;



            check_outputs(32'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pulse Start and Finish check", test_num);
            reset_dut();

            @(posedge clk);
            addr = 32'hFFFF_0000;
            data_in = 32'hAAAA_5555;
            rw = 0;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(ready == 1);
            #1;

            #1;


            check_outputs(32'hAAAA_5555, 1'b0, 1'b1);
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
        $dumpvars(0,addr, clk, data_in, rst, rw, start, data_out, error, ready);
    end

endmodule
