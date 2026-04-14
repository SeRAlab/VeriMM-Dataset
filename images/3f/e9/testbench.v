`timescale 1ns/1ps

module LZW_Compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start;
    wire [11:0] code_out;
    wire done;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LZW_Compressor dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
        .code_out(code_out),
        .done(done),
        .valid(valid)
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
            data_in = 8'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            $display("System Reset Complete");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple Literal Sequence 'ABC'", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            data_in = 8'h41;
            @(posedge clk);
            data_in = 8'h42;
            @(posedge clk);
            data_in = 8'h43;
            @(posedge clk);
            start = 0;


            wait(done == 1'b1);



            #1;




            check_outputs(12'h043, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Repeated Sequence 'ABAB'", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            data_in = 8'h41;
            @(posedge clk);
            data_in = 8'h42;
            @(posedge clk);
            data_in = 8'h41;
            @(posedge clk);
            data_in = 8'h42;
            @(posedge clk);
            start = 0;


            wait(done == 1'b1);


            #1;



            check_outputs(12'h100, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Long Repeated Pattern 'AAAA'", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            data_in = 8'h41;
            @(posedge clk);
            data_in = 8'h41;
            @(posedge clk);
            data_in = 8'h41;
            @(posedge clk);
            data_in = 8'h41;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);



            #1;




            check_outputs(12'h100, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Character Input", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            data_in = 8'h5A;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);


            #1;



            check_outputs(12'h05A, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-operation Reset", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            data_in = 8'h41;
            @(posedge clk);
            data_in = 8'h42;


            #2 rst = 1;
            @(posedge clk);
            rst = 0;
            start = 0;

            repeat(5) @(posedge clk);


            #1;



            check_outputs(12'h000, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LZW_Compressor Testbench");
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
        input [11:0] expected_code_out;
        input expected_done;
        input expected_valid;
        begin
            if (expected_code_out === (expected_code_out ^ code_out ^ expected_code_out) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: code_out=%h, done=%b, valid=%b",
                         code_out, done, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code_out=%h, done=%b, valid=%b",
                         expected_code_out, expected_done, expected_valid);
                $display("  Got:      code_out=%h, done=%b, valid=%b",
                         code_out, done, valid);
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
        $dumpvars(0,clk, data_in, rst, start, code_out, done, valid);
    end

endmodule
