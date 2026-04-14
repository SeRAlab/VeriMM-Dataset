`timescale 1ns/1ps

module RLE_Compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    wire [15:0] compressed_out;
    wire output_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE_Compressor dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .compressed_out(compressed_out),
        .output_valid(output_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in <= 8'h0;
            data_valid <= 1'b0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: Simple Run (4 identical bytes)", test_num);
            reset_dut();

            @(posedge clk);
            data_in <= 8'hAA;
            data_valid <= 1'b1;
            repeat(4) @(posedge clk);


            data_in <= 8'hBB;
            @(posedge clk);
            data_valid <= 1'b0;


            #1;



            check_outputs(16'hAA04, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Single Byte Run", test_num);
            reset_dut();

            @(posedge clk);
            data_in <= 8'h12;
            data_valid <= 1'b1;
            @(posedge clk);


            data_in <= 8'h34;
            @(posedge clk);
            data_valid <= 1'b0;


            #1;



            check_outputs(16'h1201, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nTest %0d: Maximum Length Run (255 bytes)", test_num);
            reset_dut();

            @(posedge clk);
            data_in <= 8'hFF;
            data_valid <= 1'b1;
            repeat(255) @(posedge clk);


            data_in <= 8'h00;
            @(posedge clk);
            data_valid <= 1'b0;


            #1;



            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Run with gaps in data_valid", test_num);
            reset_dut();

            @(posedge clk);
            data_in <= 8'h55;
            data_valid <= 1'b1;
            @(posedge clk);
            data_valid <= 1'b0;
            @(posedge clk);
            data_valid <= 1'b1;
            @(posedge clk);


            data_in <= 8'h66;
            @(posedge clk);
            data_valid <= 1'b0;


            #1;



            check_outputs(16'h5502, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Consecutive Runs", test_num);
            reset_dut();


            @(posedge clk);
            data_in <= 8'h01;
            data_valid <= 1'b1;
            repeat(2) @(posedge clk);


            data_in <= 8'h02;
            repeat(3) @(posedge clk);


            data_in <= 8'h03;
            @(posedge clk);
            data_valid <= 1'b0;


            #1;



            check_outputs(16'h0203, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RLE_Compressor Testbench");
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
        input [15:0] expected_compressed_out;
        input expected_output_valid;
        begin
            if (expected_compressed_out === (expected_compressed_out ^ compressed_out ^ expected_compressed_out) &&
                expected_output_valid === (expected_output_valid ^ output_valid ^ expected_output_valid)) begin
                $display("PASS");
                $display("  Outputs: compressed_out=%h, output_valid=%b",
                         compressed_out, output_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_out=%h, output_valid=%b",
                         expected_compressed_out, expected_output_valid);
                $display("  Got:      compressed_out=%h, output_valid=%b",
                         compressed_out, output_valid);
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
        $dumpvars(0,clk, data_in, data_valid, compressed_out, output_valid);
    end

endmodule
