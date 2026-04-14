`timescale 1ns/1ps

module checksum_checker_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg rst;
    wire [7:0] checksum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_checker dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .checksum_out(checksum_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 32'h0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Accumulation", test_num);
            reset_dut();
            data_in = 32'h00000005;
            @(posedge clk);
            data_in = 32'h0000000A;
            @(posedge clk);
            data_in = 32'h00000001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Modulo 256 Wrap-around", test_num);
            reset_dut();
            data_in = 32'h000000F0;
            @(posedge clk);
            data_in = 32'h00000020;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: 32-bit Large Input Values", test_num);
            reset_dut();
            data_in = 32'h00000101;
            @(posedge clk);
            data_in = 32'h12345678;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h79);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Continuous Zero Input", test_num);
            reset_dut();
            data_in = 32'h0;
            @(posedge clk);
            data_in = 32'h0;
            @(posedge clk);
            data_in = 32'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset during operation", test_num);
            reset_dut();
            data_in = 32'h000000FF;
            @(posedge clk);

            rst = 1;
            @(posedge clk);
            rst = 0;
            data_in = 32'h00000005;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Max Value Summation", test_num);
            reset_dut();
            data_in = 32'hFFFFFFFF;
            @(posedge clk);
            data_in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_checker Testbench");
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
        input [7:0] expected_checksum_out;
        begin
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h",
                         checksum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h",
                         expected_checksum_out);
                $display("  Got:      checksum_out=%h",
                         checksum_out);
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
        $dumpvars(0,clk, data_in, rst, checksum_out);
    end

endmodule
