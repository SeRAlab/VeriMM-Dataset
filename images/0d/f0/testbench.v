`timescale 1ns/1ps

module ReedSolomonEncoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    reg valid_in;
    wire [7:0] codeword_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ReedSolomonEncoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .codeword_out(codeword_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            valid_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            $display("Reset complete.");
        end
        endtask
    task send_data_stream;

        input [7:0] data_stream;
        integer i;
        begin
            valid_in = 1;
            for (i = 7; i >= 0; i = i - 1) begin
                data_in = data_stream[i];
                @(posedge clk);
            end
            valid_in = 0;
            data_in = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All Zeros Stream", test_num);
            reset_dut();
            send_data_stream(8'b00000000);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Single High Bit (MSB)", test_num);
            reset_dut();
            send_data_stream(8'b10000000);


            #1;



            check_outputs(8'hD5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Alternating Bit Pattern", test_num);
            reset_dut();
            send_data_stream(8'b10101010);
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All Ones Stream", test_num);
            reset_dut();
            send_data_stream(8'b11111111);
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Low Nibble High Pattern", test_num);
            reset_dut();
            send_data_stream(8'b00001111);
            #1;

            check_outputs(8'h0F, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ReedSolomonEncoder Testbench");
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
        input [7:0] expected_codeword_out;
        input expected_valid_out;
        begin
            if (expected_codeword_out === (expected_codeword_out ^ codeword_out ^ expected_codeword_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: codeword_out=%h, valid_out=%b",
                         codeword_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codeword_out=%h, valid_out=%b",
                         expected_codeword_out, expected_valid_out);
                $display("  Got:      codeword_out=%h, valid_out=%b",
                         codeword_out, valid_out);
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
        $dumpvars(0,clk, data_in, rst, valid_in, codeword_out, valid_out);
    end

endmodule
