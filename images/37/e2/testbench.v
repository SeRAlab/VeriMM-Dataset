`timescale 1ns/1ps

module checksum_calculator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg last_word;
    reg rst;
    wire [7:0] checksum_out;
    wire checksum_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_calculator dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .last_word(last_word),
        .rst(rst),
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
            rst = 1;
            data_in = 8'h0;
            data_valid = 0;
            last_word = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic 2-word addition (0x10 + 0x20)", test_num);
            reset_dut();

            data_in = 8'h10;
            data_valid = 1;
            last_word = 0;
            @(posedge clk);

            data_in = 8'h20;
            data_valid = 1;
            last_word = 1;
            @(posedge clk);

            data_valid = 0;
            last_word = 0;


            if (!checksum_valid) @(posedge clk);

            #1;


            check_outputs(8'h30, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Overflow check (0xFF + 0x02 = 0x01)", test_num);
            reset_dut();

            data_in = 8'hFF;
            data_valid = 1;
            last_word = 0;
            @(posedge clk);

            data_in = 8'h02;
            data_valid = 1;
            last_word = 1;
            @(posedge clk);

            data_valid = 0;
            last_word = 0;

            if (!checksum_valid) @(posedge clk);

            #1;


            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Single word input (0xAA)", test_num);
            reset_dut();

            data_in = 8'hAA;
            data_valid = 1;
            last_word = 1;
            @(posedge clk);

            data_valid = 0;
            last_word = 0;

            if (!checksum_valid) @(posedge clk);

            #1;


            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Gaps in data_valid", test_num);
            reset_dut();

            data_in = 8'h05;
            data_valid = 1;
            last_word = 0;
            @(posedge clk);

            data_valid = 0;
            @(posedge clk);
            @(posedge clk);

            data_in = 8'h0A;
            data_valid = 1;
            last_word = 1;
            @(posedge clk);

            data_valid = 0;
            last_word = 0;

            if (!checksum_valid) @(posedge clk);

            #1;


            check_outputs(8'h0F, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Multiple words (0x80 * 4 = 0x200 -> 0x00)", test_num);
            reset_dut();

            data_valid = 1;
            data_in = 8'h80; last_word = 0; @(posedge clk);
            data_in = 8'h80; last_word = 0; @(posedge clk);
            data_in = 8'h80; last_word = 0; @(posedge clk);
            data_in = 8'h80; last_word = 1; @(posedge clk);

            data_valid = 0;
            last_word = 0;

            if (!checksum_valid) @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: All zeros", test_num);
            reset_dut();

            data_in = 8'h00;
            data_valid = 1;
            last_word = 0;
            @(posedge clk);

            data_in = 8'h00;
            data_valid = 1;
            last_word = 1;
            @(posedge clk);

            data_valid = 0;
            last_word = 0;

            if (!checksum_valid) @(posedge clk);

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_calculator Testbench");
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
        $dumpvars(0,clk, data_in, data_valid, last_word, rst, checksum_out, checksum_valid);
    end

endmodule
