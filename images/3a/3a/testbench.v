`timescale 1ns/1ps

module lzw_compression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_symbol;
    reg reset;
    wire [11:0] output_code;
    wire valid_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_compression dut (
        .clk(clk),
        .input_symbol(input_symbol),
        .reset(reset),
        .output_code(output_code),
        .valid_output(valid_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_symbol = 8'h00;
            @(posedge clk);
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Symbol Processing (0x41)", test_num);
            reset_dut();
            input_symbol = 8'h41;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Literal Output Generation ('A' then 'B')", test_num);
            reset_dut();
            @(posedge clk);
            input_symbol = 8'h41;
            @(posedge clk);
            input_symbol = 8'h42;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h041, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Dictionary Entry Creation ('A' then 'A')", test_num);
            reset_dut();
            @(posedge clk);
            input_symbol = 8'h41;
            @(posedge clk);
            input_symbol = 8'h41;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h041, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Compressed String Match ('ABAB' -> Code 256)", test_num);
            reset_dut();
            @(posedge clk);
            input_symbol = 8'h41;
            @(posedge clk);
            input_symbol = 8'h42;
            @(posedge clk);
            input_symbol = 8'h41;
            @(posedge clk);
            input_symbol = 8'h42;
            @(posedge clk);
            input_symbol = 8'h43;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h100, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Extended Sequence Match", test_num);
            reset_dut();
            @(posedge clk);
            input_symbol = 8'h44;
            @(posedge clk);
            input_symbol = 8'h45;
            @(posedge clk);
            input_symbol = 8'h44;
            @(posedge clk);
            input_symbol = 8'h45;
            @(posedge clk);
            input_symbol = 8'h46;
            @(posedge clk);
            #1;
            #1;

            check_outputs(12'h100, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lzw_compression Testbench");
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
        input expected_valid_output;
        begin
            if (expected_output_code === (expected_output_code ^ output_code ^ expected_output_code) &&
                expected_valid_output === (expected_valid_output ^ valid_output ^ expected_valid_output)) begin
                $display("PASS");
                $display("  Outputs: output_code=%h, valid_output=%b",
                         output_code, valid_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_code=%h, valid_output=%b",
                         expected_output_code, expected_valid_output);
                $display("  Got:      output_code=%h, valid_output=%b",
                         output_code, valid_output);
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
        $dumpvars(0,clk, input_symbol, reset, output_code, valid_output);
    end

endmodule
