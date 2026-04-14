`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg enable;
    reg [15:0] polynomial;
    reg rst;
    wire [15:0] crc_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .polynomial(polynomial),
        .rst(rst),
        .crc_out(crc_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            enable = 0;
            data_in = 16'h0;
            polynomial = 16'h0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case 001: Data=0x1234, Poly=0x1021 (CCITT)");
            reset_dut();

            data_in = 16'h1234;
            polynomial = 16'h1021;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;


            wait(valid == 1);
            @(posedge clk);
            #1;

            check_outputs(16'h31C3, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case 002: Data=0xABCD, Poly=0x8005 (IBM)");
            reset_dut();

            data_in = 16'hABCD;
            polynomial = 16'h8005;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            wait(valid == 1);
            @(posedge clk);
            #1;

            check_outputs(16'hFD4B, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case 003: Data=0xFFFF, Poly=0x1021");
            reset_dut();

            data_in = 16'hFFFF;
            polynomial = 16'h1021;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            wait(valid == 1);
            @(posedge clk);
            #1;

            check_outputs(16'h1D0F, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case 004: Data=0x0000, Poly=0x1234");
            reset_dut();

            data_in = 16'h0000;
            polynomial = 16'h1234;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            wait(valid == 1);
            @(posedge clk);
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case 005: Data=0x5555, Poly=0x1021");
            reset_dut();

            data_in = 16'h5555;
            polynomial = 16'h1021;
            enable = 1;
            @(posedge clk);
            #1 enable = 0;

            wait(valid == 1);
            @(posedge clk);
            #1;

            check_outputs(16'h1331, 1'b1);
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
        input expected_valid;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h, valid=%b",
                         crc_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h, valid=%b",
                         expected_crc_out, expected_valid);
                $display("  Got:      crc_out=%h, valid=%b",
                         crc_out, valid);
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
        $dumpvars(0,clk, data_in, enable, polynomial, rst, crc_out, valid);
    end

endmodule
