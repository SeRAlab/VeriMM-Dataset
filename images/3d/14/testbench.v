`timescale 1ns/1ps

module lzw_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg reset;
    wire [15:0] code_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .reset(reset),
        .code_out(code_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h0;
            data_valid = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task send_byte;

        input [7:0] value;
        begin
            data_in = value;
            data_valid = 1;
            #10;
            data_valid = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple Sequence 'ABC'", test_num);
            reset_dut();

            send_byte(8'h41);
            send_byte(8'h42);
            #1;
            #1;

            check_outputs(16'd65, 1'b1);

            send_byte(8'h43);
            #1;
            #1;

            check_outputs(16'd66, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Repeated Pattern 'ABAB'", test_num);
            reset_dut();

            send_byte(8'h41);
            send_byte(8'h42);
            send_byte(8'h41);
            send_byte(8'h42);
            #1;
            if (valid_out == 0) begin
                $display("PASS: Accumulating string 'AB'");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Unexpected valid_out while accumulating");
                fail_count = fail_count + 1;
            end

            send_byte(8'h43);
            #1;
            #1;

            check_outputs(16'd256, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Long Repeated Character 'AAAA'", test_num);
            reset_dut();

            send_byte(8'h41);
            send_byte(8'h41);
            #1; #1;
 check_outputs(16'd65, 1'b1);

            send_byte(8'h41);
            send_byte(8'h42);
            #1; #1;
 check_outputs(16'd256, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset Mid-stream", test_num);
            reset_dut();

            send_byte(8'h41);
            send_byte(8'h42);

            reset_dut();

            send_byte(8'h41);
            send_byte(8'h42);
            #1; #1;
 check_outputs(16'd65, 1'b1);

            send_byte(8'h41);
            #1; #1;
 check_outputs(16'd66, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lzw_encoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [15:0] expected_code_out;
        input expected_valid_out;
        begin
            if (expected_code_out === (expected_code_out ^ code_out ^ expected_code_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: code_out=%h, valid_out=%b",
                         code_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code_out=%h, valid_out=%b",
                         expected_code_out, expected_valid_out);
                $display("  Got:      code_out=%h, valid_out=%b",
                         code_out, valid_out);
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
        $dumpvars(0,clk, data_in, data_valid, reset, code_out, valid_out);
    end

endmodule
