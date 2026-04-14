`timescale 1ns/1ps

module lzw_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_byte;
    reg reset;
    reg valid_input;
    wire [15:0] compressed_output;
    wire output_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_compressor dut (
        .clk(clk),
        .input_byte(input_byte),
        .reset(reset),
        .valid_input(valid_input),
        .compressed_output(compressed_output),
        .output_valid(output_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_byte = 0;
            valid_input = 0;
            repeat(3) @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic transition 'AB' -> Expect code 0x41", test_num);
            reset_dut();

            input_byte = 8'h41; valid_input = 1; @(posedge clk);
            input_byte = 8'h42; valid_input = 1; @(posedge clk);
            valid_input = 0;


            while (!output_valid) @(posedge clk);
            #1;

            check_outputs(16'h0041, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Repeated character 'AAAA' -> Expect dictionary code 256", test_num);
            reset_dut();

            input_byte = 8'h41; valid_input = 1; @(posedge clk);
            input_byte = 8'h41; valid_input = 1; @(posedge clk);
            input_byte = 8'h41; valid_input = 1; @(posedge clk);
            input_byte = 8'h41; valid_input = 1; @(posedge clk);
            valid_input = 0;


            while (compressed_output != 16'd256 || !output_valid) @(posedge clk);
            #1;

            check_outputs(16'd256, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pattern match 'ABABC' -> Expect code 256", test_num);
            reset_dut();

            input_byte = 8'h41; valid_input = 1; @(posedge clk);
            input_byte = 8'h42; valid_input = 1; @(posedge clk);
            input_byte = 8'h41; valid_input = 1; @(posedge clk);
            input_byte = 8'h42; valid_input = 1; @(posedge clk);
            input_byte = 8'h43; valid_input = 1; @(posedge clk);
            valid_input = 0;


            while (compressed_output != 16'd256 || !output_valid) @(posedge clk);
            #1;

            check_outputs(16'd256, 1'b1);
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
        input [15:0] expected_compressed_output;
        input expected_output_valid;
        begin
            if (expected_compressed_output === (expected_compressed_output ^ compressed_output ^ expected_compressed_output) &&
                expected_output_valid === (expected_output_valid ^ output_valid ^ expected_output_valid)) begin
                $display("PASS");
                $display("  Outputs: compressed_output=%h, output_valid=%b",
                         compressed_output, output_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_output=%h, output_valid=%b",
                         expected_compressed_output, expected_output_valid);
                $display("  Got:      compressed_output=%h, output_valid=%b",
                         compressed_output, output_valid);
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
        $dumpvars(0,clk, input_byte, reset, valid_input, compressed_output, output_valid);
    end

endmodule
