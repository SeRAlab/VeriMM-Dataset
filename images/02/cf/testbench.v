`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] input_bits;
    reg rst;
    reg [1:0] state;
    wire [1:0] decoded_bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .input_bits(input_bits),
        .rst(rst),
        .state(state),
        .decoded_bits(decoded_bits)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_bits = 2'b00;
            state = 2'b00;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State 00, Input 00 (Clean Path)", test_num);
            reset_dut();
            state = 2'b00;
            input_bits = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State 01, Input 11 (Clean Path)", test_num);
            reset_dut();
            state = 2'b01;
            input_bits = 2'b11;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State 10, Input 10 (Clean Path)", test_num);
            reset_dut();
            state = 2'b10;
            input_bits = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State 00, Input 01 (Noisy Input - Expect Correction)", test_num);
            reset_dut();
            state = 2'b00;
            input_bits = 2'b01;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State 11, Input 01 (Clean Path)", test_num);
            reset_dut();
            state = 2'b11;
            input_bits = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-cycle transition check", test_num);
            reset_dut();


            state = 2'b00;
            input_bits = 2'b11;
            @(posedge clk);
            #1;


            state = 2'b11;
            input_bits = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'b10);
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
        input [1:0] expected_decoded_bits;
        begin
            if (expected_decoded_bits === (expected_decoded_bits ^ decoded_bits ^ expected_decoded_bits)) begin
                $display("PASS");
                $display("  Outputs: decoded_bits=%h",
                         decoded_bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_bits=%h",
                         expected_decoded_bits);
                $display("  Got:      decoded_bits=%h",
                         decoded_bits);
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
        $dumpvars(0,clk, input_bits, rst, state, decoded_bits);
    end

endmodule
