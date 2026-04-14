`timescale 1ns/1ps

module reed_solomon_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] message_in;
    reg rst;
    reg valid_in;
    wire [7:0] codeword_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reed_solomon_encoder dut (
        .clk(clk),
        .message_in(message_in),
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
            message_in = 4'd0;
            valid_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Input Message 4'h0");
            test_num = test_num + 1;
            reset_dut();
            message_in = 4'h0;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            repeat(10) begin
                if (valid_out) break;
                @(posedge clk);
            end
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input Message 4'h1");
            test_num = test_num + 1;
            reset_dut();
            message_in = 4'h1;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            repeat(10) begin
                if (valid_out) break;
                @(posedge clk);
            end
            #1;

            check_outputs(8'h11, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Input Message 4'h5");
            test_num = test_num + 1;
            reset_dut();
            message_in = 4'h5;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            repeat(10) begin
                if (valid_out) break;
                @(posedge clk);
            end
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Input Message 4'hA");
            test_num = test_num + 1;
            reset_dut();
            message_in = 4'hA;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            repeat(10) begin
                if (valid_out) break;
                @(posedge clk);
            end
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Input Message 4'hF");
            test_num = test_num + 1;
            reset_dut();
            message_in = 4'hF;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            repeat(10) begin
                if (valid_out) break;
                @(posedge clk);
            end
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reed_solomon_encoder Testbench");
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
        $dumpvars(0,clk, message_in, rst, valid_in, codeword_out, valid_out);
    end

endmodule
