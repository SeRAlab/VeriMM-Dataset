`timescale 1ns/1ps

module lzw_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg valid_in;
    wire [9:0] code_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_compressor dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid_in(valid_in),
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
            data_in = 0;
            valid_in = 0;
            #20;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase %03d: 'AB' - Expect code for 'A'", test_num);
            reset_dut();
            send_byte(8'd65);
            send_byte(8'd66);

            wait(valid_out);
            #1;
            #1;

            check_outputs(10'd65, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase %03d: 'ABC' - Expect code for 'B'", test_num);
            reset_dut();
            send_byte(8'd65);
            send_byte(8'd66);
            send_byte(8'd67);


            @(posedge valid_out);
            @(negedge valid_out);
            wait(valid_out);
            #1;
            #1;

            check_outputs(10'd66, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase %03d: 'AAAA' - Expect code 256 (AA)", test_num);
            reset_dut();
            send_byte(8'd65);
            send_byte(8'd65);
            send_byte(8'd65);
            send_byte(8'd65);


            @(posedge valid_out);
            @(negedge valid_out);
            wait(valid_out);
            #1;
            #1;

            check_outputs(10'd256, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase %03d: 'ABABABAC' - Expect code 258 (ABA)", test_num);
            reset_dut();
            send_byte(8'd65);
            send_byte(8'd66);
            send_byte(8'd65);
            send_byte(8'd66);
            send_byte(8'd65);
            send_byte(8'd66);
            send_byte(8'd65);
            send_byte(8'd67);


            repeat(4) wait(valid_out) @(negedge clk);
            #1;
            #1;

            check_outputs(10'd258, 1'b1);
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
        input [9:0] expected_code_out;
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
        $dumpvars(0,clk, data_in, reset, valid_in, code_out, valid_out);
    end

endmodule
