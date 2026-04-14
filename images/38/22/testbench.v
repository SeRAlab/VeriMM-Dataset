`timescale 1ns/1ps

module lzw_decompressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] compressed_in;
    reg reset;
    wire [7:0] decompressed_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_decompressor dut (
        .clk(clk),
        .compressed_in(compressed_in),
        .reset(reset),
        .decompressed_out(decompressed_out),
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
            compressed_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Literal 'A' (0x41)", test_num);
            reset_dut();

            compressed_in = 8'h41;
            @(posedge clk);


            repeat(5) begin
                if (valid_out) break;
                @(posedge clk);
            end

            #1;


            check_outputs(8'h41, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Literal 'Z' (0x5A)", test_num);
            reset_dut();

            compressed_in = 8'h5A;
            @(posedge clk);

            repeat(5) begin
                if (valid_out) break;
                @(posedge clk);
            end

            #1;


            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequence 'A' then 'B'", test_num);
            reset_dut();


            compressed_in = 8'h41;
            @(posedge clk);
            wait(valid_out);
            @(posedge clk);


            compressed_in = 8'h42;
            @(posedge clk);

            repeat(5) begin
                if (valid_out) break;
                @(posedge clk);
            end


            #1;



            check_outputs(8'h42, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dictionary Sequence Retrieval (AA)", test_num);
            reset_dut();


            compressed_in = 8'h41;
            @(posedge clk);
            wait(valid_out);
            @(posedge clk);


            compressed_in = 8'h41;
            @(posedge clk);
            wait(valid_out);
            @(posedge clk);


            compressed_in = 8'h80;
            @(posedge clk);


            wait(valid_out);
            @(posedge clk);


            repeat(5) begin
                if (valid_out) break;
                @(posedge clk);
            end


            #1;



            check_outputs(8'h41, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lzw_decompressor Testbench");
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
        input [7:0] expected_decompressed_out;
        input expected_valid_out;
        begin
            if (expected_decompressed_out === (expected_decompressed_out ^ decompressed_out ^ expected_decompressed_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: decompressed_out=%h, valid_out=%b",
                         decompressed_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decompressed_out=%h, valid_out=%b",
                         expected_decompressed_out, expected_valid_out);
                $display("  Got:      decompressed_out=%h, valid_out=%b",
                         decompressed_out, valid_out);
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
        $dumpvars(0,clk, compressed_in, reset, decompressed_out, valid_out);
    end

endmodule
