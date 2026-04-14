`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg reset;
    reg start;
    wire [15:0] crc_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .start(start),
        .crc_out(crc_out),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            data_in = 16'h0000;
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
            $display("Test %0d: Data In = 0x0000 (Zero Input)", test_num);
            reset_dut();
            data_in = 16'h0000;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done === 1);
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data In = 0x0001 (Single Bit LSB)", test_num);
            reset_dut();
            data_in = 16'h0001;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done === 1);
            @(posedge clk);
            #1 #1;
 check_outputs(16'h1021, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data In = 0x8000 (Single Bit MSB)", test_num);
            reset_dut();
            data_in = 16'h8000;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done === 1);
            @(posedge clk);
            #1 #1;
 check_outputs(16'h9440, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data In = 0x1234 (Arbitrary Pattern)", test_num);
            reset_dut();
            data_in = 16'h1234;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done === 1);
            @(posedge clk);
            #1 #1;
 check_outputs(16'h11CF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data In = 0xFFFF (All Ones)", test_num);
            reset_dut();
            data_in = 16'hFFFF;
            start = 1;
            @(posedge clk);
            #1 start = 0;

            wait(done === 1);
            @(posedge clk);
            #1 #1;
 check_outputs(16'h1D0F, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc_generator Testbench");
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
        input [15:0] expected_crc_out;
        input expected_done;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h, done=%b",
                         crc_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h, done=%b",
                         expected_crc_out, expected_done);
                $display("  Got:      crc_out=%h, done=%b",
                         crc_out, done);
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
        $dumpvars(0,clk, data_in, reset, start, crc_out, done);
    end

endmodule
