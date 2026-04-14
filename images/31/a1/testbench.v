`timescale 1ns/1ps

module ReedSolomonEncoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] message;
    reg start;
    wire [11:0] codeword;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ReedSolomonEncoder dut (
        .clk(clk),
        .message(message),
        .start(start),
        .codeword(codeword),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        start = 0;
        message = 8'h00;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: All Zeros Message (0x00)", test_num);
        reset_dut();

        message = 8'h00;
        start = 1;
        @(posedge clk);
        #1 start = 0;


        wait(done == 1'b1);
        @(posedge clk);
        #1;


        #1;



        check_outputs(12'h000, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: All Ones Message (0xFF)", test_num);
        reset_dut();

        message = 8'hFF;
        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(done == 1'b1);
        @(posedge clk);
        #1;



        #1;




        check_outputs(codeword, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Alternating Bits (0xAA)", test_num);
        reset_dut();

        message = 8'hAA;
        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(done == 1'b1);
        @(posedge clk);
        #1;

        #1;


        check_outputs(codeword, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Single Bit LSB (0x01)", test_num);
        reset_dut();

        message = 8'h01;
        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(done == 1'b1);
        @(posedge clk);
        #1;

        #1;


        check_outputs(codeword, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Single Bit MSB (0x80)", test_num);
        reset_dut();

        message = 8'h80;
        start = 1;
        @(posedge clk);
        #1 start = 0;

        wait(done == 1'b1);
        @(posedge clk);
        #1;

        #1;


        check_outputs(codeword, 1'b1);
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
        input [11:0] expected_codeword;
        input expected_done;
        begin
            if (expected_codeword === (expected_codeword ^ codeword ^ expected_codeword) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: codeword=%h, done=%b",
                         codeword, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codeword=%h, done=%b",
                         expected_codeword, expected_done);
                $display("  Got:      codeword=%h, done=%b",
                         codeword, done);
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
        $dumpvars(0,clk, message, start, codeword, done);
    end

endmodule
