`timescale 1ns/1ps

module lzw_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_char;
    reg reset;
    reg start;
    wire [11:0] output_code;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_compressor dut (
        .clk(clk),
        .input_char(input_char),
        .reset(reset),
        .start(start),
        .output_code(output_code),
        .valid(valid)
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
            input_char = 0;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Single Character Transition", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            input_char = 8'h41;
            @(posedge clk);
            input_char = 8'h42;


            wait(valid === 1);
            #1;

            check_outputs(12'h041, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Pattern Recognition (AA)", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;


            input_char = 8'h41;
            @(posedge clk);


            input_char = 8'h41;
            wait(valid === 1);
            @(posedge clk);


            input_char = 8'h41;
            @(posedge clk);


            input_char = 8'h42;
            wait(valid === 1);

            #1;


            check_outputs(12'h100, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Multiple Literals", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            input_char = 8'h01;
            @(posedge clk);
            input_char = 8'h02;
            wait(valid === 1);
            @(posedge clk);
            input_char = 8'h03;
            wait(valid === 1);

            #1;


            check_outputs(12'h002, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Complex Sequence (ABABA)", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            input_char = 8'h41;
            @(posedge clk);
            input_char = 8'h42;
            wait(valid === 1);
            @(posedge clk);
            input_char = 8'h41;
            wait(valid === 1);
            @(posedge clk);
            input_char = 8'h42;
            @(posedge clk);
            input_char = 8'h41;
            wait(valid === 1);

            #1;


            check_outputs(12'h100, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Mid-stream Reset", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            input_char = 8'h58;
            @(posedge clk);
            input_char = 8'h59;
            wait(valid === 1);


            reset = 1;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);


            input_char = 8'h43;
            @(posedge clk);
            input_char = 8'h44;
            wait(valid === 1);

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
        $display("lzw_compressor Testbench");
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
        input [11:0] expected_output_code;
        input expected_valid;
        begin
            if (expected_output_code === (expected_output_code ^ output_code ^ expected_output_code) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: output_code=%h, valid=%b",
                         output_code, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_code=%h, valid=%b",
                         expected_output_code, expected_valid);
                $display("  Got:      output_code=%h, valid=%b",
                         output_code, valid);
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
        $dumpvars(0,clk, input_char, reset, start, output_code, valid);
    end

endmodule
