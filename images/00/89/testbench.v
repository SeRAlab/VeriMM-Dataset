`timescale 1ns/1ps

module crc32_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg data_valid;
    reg rst_n;
    wire [31:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc32_generator dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst_n(rst_n),
        .crc_out(crc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 32'h0;
            data_valid = 0;
            #15;
            rst_n = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: All Zeros Data", test_num);
            reset_dut();
            data_in = 32'h00000000;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: All Ones Data", test_num);
            reset_dut();
            data_in = 32'hFFFFFFFF;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;

            #1;


            check_outputs(32'hFF46205B);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Hex Pattern 0x12345678", test_num);
            reset_dut();
            data_in = 32'h12345678;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;
            #1;

            check_outputs(32'hDF8CE0F5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Alternating Bits (A)", test_num);
            reset_dut();
            data_in = 32'hAAAAAAAA;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;
            #1;

            check_outputs(32'h7EAD2718);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Alternating Bits (5)", test_num);
            reset_dut();
            data_in = 32'h55555555;
            data_valid = 1;
            @(posedge clk);
            #1;
            data_valid = 0;
            #1;

            check_outputs(32'hB2A66D8E);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc32_generator Testbench");
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
        input [31:0] expected_crc_out;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
        $dumpvars(0,clk, data_in, data_valid, rst_n, crc_out);
    end

endmodule
