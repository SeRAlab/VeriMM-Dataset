`timescale 1ns/1ps

module crc8_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc8_generator dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .crc_out(crc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            data_in = 8'h00;
            @(posedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Zero Input", test_num);
            reset_dut();
            data_in = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Single Byte 0x01", test_num);
            reset_dut();
            data_in = 8'h01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Single Byte 0xFF", test_num);
            reset_dut();
            data_in = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Multi-byte Sequence (0x01, 0x02)", test_num);
            reset_dut();
            data_in = 8'h01;
            @(posedge clk);
            data_in = 8'h02;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h1B);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Long sequence (DE AD BE EF)", test_num);
            reset_dut();
            data_in = 8'hDE; @(posedge clk);
            data_in = 8'hAD; @(posedge clk);
            data_in = 8'hBE; @(posedge clk);
            data_in = 8'hEF; @(posedge clk);
            #2;
            #1;

            check_outputs(8'h4D);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Reset mid-calculation", test_num);
            reset_dut();
            data_in = 8'hAA; @(posedge clk);
            data_in = 8'hBB; @(posedge clk);

            reset = 1; @(posedge clk);
            reset = 0;
            data_in = 8'h01; @(posedge clk);
            #2;

            #1;


            check_outputs(8'h07);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc8_generator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_crc_out;
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
        $dumpvars(0,clk, data_in, reset, crc_out);
    end

endmodule
