`timescale 1ns/1ps

module LZW_Compressor_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] char_in;
    reg clk;
    reg reset;
    reg valid_in;
    wire [7:0] compressed_out;
    wire done;
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
        .valid_in(valid_in),
        .compressed_out(compressed_out),
        .done(done),
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
            char_in = 8'h0;
            valid_in = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task send_char;

        input [7:0] data;
        begin
            char_in = data;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;

            repeat(1) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase%03d: Single Character 'A'...", test_num);
            reset_dut();

            send_char(8'h41);


            wait(done);
            @(posedge clk);


            #1;



            check_outputs(8'h41, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase%03d: Sequence 'ABAB'...", test_num);
            reset_dut();

            send_char(8'h41);
            send_char(8'h42);
            send_char(8'h41);
            send_char(8'h42);

            wait(done);
            @(posedge clk);






            #1;







            check_outputs(8'h00, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase%03d: Non-repeating sequence...", test_num);
            reset_dut();

            send_char(8'h01);
            send_char(8'h02);
            send_char(8'h03);

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(8'h03, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase%03d: Long sequence 'AAAAA'...", test_num);
            reset_dut();

            repeat(5) send_char(8'h41);

            wait(done);
            @(posedge clk);



            if (done === 1'b1 && valid_out === 1'b1) begin
                $display("PASS: Done asserted for long sequence");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Done not asserted properly");
                fail_count = fail_count + 1;
            end
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
        input [7:0] expected_compressed_out;
        input expected_done;
        input expected_valid_out;
        begin
            if (expected_compressed_out === (expected_compressed_out ^ compressed_out ^ expected_compressed_out) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: compressed_out=%h, done=%b, valid_out=%b",
                         compressed_out, done, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_out=%h, done=%b, valid_out=%b",
                         expected_compressed_out, expected_done, expected_valid_out);
                $display("  Got:      compressed_out=%h, done=%b, valid_out=%b",
                         compressed_out, done, valid_out);
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
        $dumpvars(0,char_in, clk, reset, valid_in, compressed_out, done, valid_out);
    end

endmodule
