`timescale 1ns/1ps

module crc_3bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg data_valid;
    reg rst;
    wire [2:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_3bit dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
        .crc_out(crc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 4'b0;
            data_valid = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'b0000;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'b1101;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'b1000;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'b1011;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'b1111;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'b0110;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 4'b0101;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(3'b110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc_3bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [2:0] expected_crc_out;
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
        $dumpvars(0,clk, data_in, data_valid, rst, crc_out);
    end

endmodule
