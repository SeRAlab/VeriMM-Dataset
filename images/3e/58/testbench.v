`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] input_bits;
    reg reset;
    wire [3:0] subcarrier_0;
    wire [3:0] subcarrier_1;
    wire [3:0] subcarrier_2;
    wire [3:0] subcarrier_3;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_modulator dut (
        .clk(clk),
        .input_bits(input_bits),
        .reset(reset),
        .subcarrier_0(subcarrier_0),
        .subcarrier_1(subcarrier_1),
        .subcarrier_2(subcarrier_2),
        .subcarrier_3(subcarrier_3),
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
            input_bits = 8'b0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros (00 00 00 00)", test_num);
            reset_dut();
            input_bits = 8'b00000000;


            wait(valid);
            @(posedge clk);


            #1;



            check_outputs(4'h5, 4'h5, 4'h5, 4'h5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones (11 11 11 11)", test_num);
            reset_dut();
            input_bits = 8'b11111111;

            wait(valid);
            @(posedge clk);


            #1;



            check_outputs(4'hF, 4'hF, 4'hF, 4'hF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Pairs (10 01 10 01)", test_num);
            reset_dut();
            input_bits = 8'b10011001;

            wait(valid);
            @(posedge clk);



            #1;




            check_outputs(4'hD, 4'h7, 4'hD, 4'h7, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Unique Subcarriers (11 10 01 00)", test_num);
            reset_dut();
            input_bits = 8'b11100100;

            wait(valid);
            @(posedge clk);


            #1;



            check_outputs(4'h5, 4'hD, 4'h7, 4'hF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Bit Reversal (00 01 10 11)", test_num);
            reset_dut();
            input_bits = 8'b00011011;

            wait(valid);
            @(posedge clk);


            #1;



            check_outputs(4'hF, 4'h7, 4'hD, 4'h5, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ofdm_modulator Testbench");
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
        input [3:0] expected_subcarrier_0;
        input [3:0] expected_subcarrier_1;
        input [3:0] expected_subcarrier_2;
        input [3:0] expected_subcarrier_3;
        input expected_valid;
        begin
            if (expected_subcarrier_0 === (expected_subcarrier_0 ^ subcarrier_0 ^ expected_subcarrier_0) &&
                expected_subcarrier_1 === (expected_subcarrier_1 ^ subcarrier_1 ^ expected_subcarrier_1) &&
                expected_subcarrier_2 === (expected_subcarrier_2 ^ subcarrier_2 ^ expected_subcarrier_2) &&
                expected_subcarrier_3 === (expected_subcarrier_3 ^ subcarrier_3 ^ expected_subcarrier_3) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: subcarrier_0=%h, subcarrier_1=%h, subcarrier_2=%h, subcarrier_3=%h, valid=%b",
                         subcarrier_0, subcarrier_1, subcarrier_2, subcarrier_3, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: subcarrier_0=%h, subcarrier_1=%h, subcarrier_2=%h, subcarrier_3=%h, valid=%b",
                         expected_subcarrier_0, expected_subcarrier_1, expected_subcarrier_2, expected_subcarrier_3, expected_valid);
                $display("  Got:      subcarrier_0=%h, subcarrier_1=%h, subcarrier_2=%h, subcarrier_3=%h, valid=%b",
                         subcarrier_0, subcarrier_1, subcarrier_2, subcarrier_3, valid);
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
        $dumpvars(0,clk, input_bits, reset, subcarrier_0, subcarrier_1, subcarrier_2, subcarrier_3, valid);
    end

endmodule
