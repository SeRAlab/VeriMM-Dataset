`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] input_bits;
    reg reset;
    wire [1:0] decoded_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .input_bits(input_bits),
        .reset(reset),
        .decoded_output(decoded_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_bits = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Sequence", test_num);
            reset_dut();

            input_bits = 2'b00; @(posedge clk); #1;
            input_bits = 2'b00; @(posedge clk); #1;
            input_bits = 2'b00; @(posedge clk); #1;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Transition Sequence", test_num);
            reset_dut();

            input_bits = 2'b11; @(posedge clk); #1;
            input_bits = 2'b01; @(posedge clk); #1;
            input_bits = 2'b10; @(posedge clk); #1;


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Error Correction Check", test_num);
            reset_dut();


            input_bits = 2'b11; @(posedge clk); #1;
            input_bits = 2'b11; @(posedge clk); #1;
            input_bits = 2'b10; @(posedge clk); #1;


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternative Path Sequence", test_num);
            reset_dut();

            input_bits = 2'b10; @(posedge clk); #1;
            input_bits = 2'b10; @(posedge clk); #1;
            input_bits = 2'b11; @(posedge clk); #1;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Activity Sequence", test_num);
            reset_dut();

            input_bits = 2'b11; @(posedge clk); #1;
            input_bits = 2'b00; @(posedge clk); #1;
            input_bits = 2'b11; @(posedge clk); #1;
            input_bits = 2'b00; @(posedge clk); #1;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Value Inputs", test_num);
            reset_dut();

            input_bits = 2'b11; @(posedge clk); #1;
            input_bits = 2'b11; @(posedge clk); #1;
            input_bits = 2'b11; @(posedge clk); #1;

            #1;


            check_outputs(2'b11);
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
        input [1:0] expected_decoded_output;
        begin
            if (expected_decoded_output === (expected_decoded_output ^ decoded_output ^ expected_decoded_output)) begin
                $display("PASS");
                $display("  Outputs: decoded_output=%h",
                         decoded_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_output=%h",
                         expected_decoded_output);
                $display("  Got:      decoded_output=%h",
                         decoded_output);
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
        $dumpvars(0,clk, input_bits, reset, decoded_output);
    end

endmodule
