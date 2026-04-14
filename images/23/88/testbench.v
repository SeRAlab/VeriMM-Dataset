`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_bits;
    reg rst;
    wire [3:0] output_bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .input_bits(input_bits),
        .rst(rst),
        .output_bits(output_bits)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_bits = 8'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            input_bits = 8'b0000_0000;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();


            input_bits = 8'b1111_1111;

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            input_bits = 8'b1010_1010;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            input_bits = 8'b0101_0101;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            input_bits = 8'b1101_1100;
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            input_bits = 8'b0000_0001;
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("viterbi_decoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [3:0] expected_output_bits;
        begin
            if (expected_output_bits === (expected_output_bits ^ output_bits ^ expected_output_bits)) begin
                $display("PASS");
                $display("  Outputs: output_bits=%h",
                         output_bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_bits=%h",
                         expected_output_bits);
                $display("  Got:      output_bits=%h",
                         output_bits);
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
        $dumpvars(0,clk, input_bits, rst, output_bits);
    end

endmodule
