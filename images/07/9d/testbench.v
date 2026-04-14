`timescale 1ns/1ps

module lzw_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [15:0] compressed_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_compressor dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .compressed_out(compressed_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Literal Output ('A' then 'B')", test_num);
            reset_dut();

            data_in = 8'h41;
            @(posedge clk);

            data_in = 8'h42;
            @(posedge clk);


            while (!valid_out) @(posedge clk);

            #1;


            check_outputs(16'h0041, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Dictionary Code Output (Sequence ABAB...)", test_num);
            reset_dut();

            data_in = 8'h41; @(posedge clk);
            data_in = 8'h42; @(posedge clk);


            while (!valid_out) @(posedge clk);
            @(posedge clk);

            data_in = 8'h41; @(posedge clk);
            data_in = 8'h42; @(posedge clk);
            data_in = 8'h43; @(posedge clk);

            while (!valid_out) @(posedge clk);


            #1;



            check_outputs(16'h0100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Repeating Sequence ('XXXXXY')", test_num);
            reset_dut();

            data_in = 8'h58; @(posedge clk);
            data_in = 8'h58; @(posedge clk);
            data_in = 8'h58; @(posedge clk);
            data_in = 8'h58; @(posedge clk);
            data_in = 8'h58; @(posedge clk);
            data_in = 8'h59; @(posedge clk);


            repeat(2) begin
                while(!valid_out) @(posedge clk);
                @(posedge clk);
            end

            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(16'h0100, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lzw_compressor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input [15:0] expected_compressed_out;
        input expected_valid_out;
        begin
            if (expected_compressed_out === (expected_compressed_out ^ compressed_out ^ expected_compressed_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: compressed_out=%h, valid_out=%b",
                         compressed_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_out=%h, valid_out=%b",
                         expected_compressed_out, expected_valid_out);
                $display("  Got:      compressed_out=%h, valid_out=%b",
                         compressed_out, valid_out);
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
        $dumpvars(0,clk, data_in, reset, compressed_out, valid_out);
    end

endmodule
