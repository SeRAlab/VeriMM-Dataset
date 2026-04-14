`timescale 1ns/1ps

module LZW_Compressor_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] char_in;
    reg clk;
    reg reset;
    reg valid;
    wire [11:0] code_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LZW_Compressor dut (
        .char_in(char_in),
        .clk(clk),
        .reset(reset),
        .valid(valid),
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
            char_in = 0;
            valid = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simple Sequence 'ABC'", test_num);
            reset_dut();


            char_in = 8'd65; valid = 1; @(posedge clk);

            char_in = 8'd66; valid = 1; @(posedge clk);

            char_in = 8'd67; valid = 1; @(posedge clk);


            valid = 0;
            char_in = 0;


            repeat(2) @(posedge clk);


            #1;



            check_outputs(12'd67, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Repeating Sequence 'AAAAA'", test_num);
            reset_dut();

            char_in = 8'd65; valid = 1; repeat(5) @(posedge clk);

            valid = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(12'd256, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pattern 'ABAB'", test_num);
            reset_dut();

            char_in = 8'd65; valid = 1; @(posedge clk);
            char_in = 8'd66; valid = 1; @(posedge clk);
            char_in = 8'd65; valid = 1; @(posedge clk);
            char_in = 8'd66; valid = 1; @(posedge clk);

            valid = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(12'd256, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Character 'Z'", test_num);
            reset_dut();

            char_in = 8'd90; valid = 1; @(posedge clk);
            valid = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(12'd90, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LZW_Compressor Testbench");
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
        input [11:0] expected_code_out;
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
        $dumpvars(0,char_in, clk, reset, valid, code_out, valid_out);
    end

endmodule
