`timescale 1ns/1ps

module LZW_Compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg valid;
    wire [11:0] compressed_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LZW_Compressor dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
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
            valid = 0;
            repeat(2) @(posedge clk);
            #2 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Character 'A'", test_num);
            reset_dut();

            data_in = 8'h41; valid = 1; @(posedge clk);
            valid = 0;


            while(!valid_out) @(posedge clk);
            #1;

            check_outputs(12'h041, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Repeated Sequence 'AAAAAA'", test_num);
            reset_dut();

            repeat(6) begin
                data_in = 8'h41; valid = 1; @(posedge clk);
            end
            valid = 0;


            while(!valid_out) @(posedge clk);
            #1;

            check_outputs(12'h101, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pattern 'ABABABA'", test_num);
            reset_dut();


            data_in = 8'h41; valid = 1; @(posedge clk);
            data_in = 8'h42; valid = 1; @(posedge clk);
            data_in = 8'h41; valid = 1; @(posedge clk);
            data_in = 8'h42; valid = 1; @(posedge clk);
            data_in = 8'h41; valid = 1; @(posedge clk);
            data_in = 8'h42; valid = 1; @(posedge clk);
            data_in = 8'h41; valid = 1; @(posedge clk);
            valid = 0;


            while(!valid_out) @(posedge clk);
            #1;

            check_outputs(12'h102, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequence 'ABCABC'", test_num);
            reset_dut();

            data_in = 8'h41; valid = 1; @(posedge clk);
            data_in = 8'h42; valid = 1; @(posedge clk);
            data_in = 8'h43; valid = 1; @(posedge clk);
            data_in = 8'h41; valid = 1; @(posedge clk);
            data_in = 8'h42; valid = 1; @(posedge clk);
            data_in = 8'h43; valid = 1; @(posedge clk);
            valid = 0;


            while(!valid_out) @(posedge clk);
            #1;

            check_outputs(12'h043, 1'b1);
            @(posedge clk);
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
        input [11:0] expected_compressed_out;
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
        $dumpvars(0,clk, data_in, reset, valid, compressed_out, valid_out);
    end

endmodule
