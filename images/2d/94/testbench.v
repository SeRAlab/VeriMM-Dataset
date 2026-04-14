`timescale 1ns/1ps

module checksum_generator_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] checksum_in;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] checksum_out;
    wire checksum_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_generator dut (
        .checksum_in(checksum_in),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .checksum_out(checksum_out),
        .checksum_valid(checksum_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h00;
            checksum_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: Single byte accumulation (0x15)", test_num);
            reset_dut();
            data_in = 8'h15;
            checksum_in = 8'h15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h15, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: Multiple bytes accumulation (0x10 + 0x20 + 0x05)", test_num);
            reset_dut();
            data_in = 8'h10; @(posedge clk);
            data_in = 8'h20; @(posedge clk);
            data_in = 8'h05;
            checksum_in = 8'h35;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h35, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: Modulo 256 wrap-around (0xFF + 0x02)", test_num);
            reset_dut();
            data_in = 8'hFF; @(posedge clk);
            data_in = 8'h02;
            checksum_in = 8'h01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Incorrect checksum input", test_num);
            reset_dut();
            data_in = 8'hAA;
            checksum_in = 8'hBB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA, 1'b0);
        end
        endtask

    task testcase006;

        reg [7:0] running_sum;
        integer i;
        begin
            test_num = 6;
            $display("Test Case %03d: Large sequence (8 bytes)", test_num);
            reset_dut();
            running_sum = 0;
            for (i = 1; i <= 8; i = i + 1) begin
                data_in = i;
                running_sum = running_sum + i;
                @(posedge clk);
            end
            checksum_in = running_sum;
            #1;
            #1;

            check_outputs(running_sum, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_generator Testbench");
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
        input expected_checksum_valid;
        begin
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out) &&
                expected_checksum_valid === (expected_checksum_valid ^ checksum_valid ^ expected_checksum_valid)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h, checksum_valid=%b",
                         checksum_out, checksum_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h, checksum_valid=%b",
                         expected_checksum_out, expected_checksum_valid);
                $display("  Got:      checksum_out=%h, checksum_valid=%b",
                         checksum_out, checksum_valid);
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
        $dumpvars(0,checksum_in, clk, data_in, reset, checksum_out, checksum_valid);
    end

endmodule
