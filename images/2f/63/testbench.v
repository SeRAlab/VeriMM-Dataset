`timescale 1ns/1ps

module sha256_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] message;
    reg rst;
    reg start;
    wire [255:0] hash_output;
    wire output_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sha256_hash dut (
        .clk(clk),
        .message(message),
        .rst(rst),
        .start(start),
        .hash_output(hash_output),
        .output_ready(output_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            message = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase %03d: 512-bit Zero Message", test_num);
            reset_dut();
            message = 512'h0;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(output_ready == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(256'hda5698d64aa0c197ef9c9fcb15101566a21af8910f135293d078174780bb29d9, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase %03d: 512-bit All-Ones Message", test_num);
            reset_dut();
            message = {64{8'hFF}};
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(output_ready == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(256'hcf5b3670606d64939b4b0e599974261d7696417537b98d2543e5c924a6e0c03c, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        reg [511:0] msg_pattern;
        begin
            test_num = 3;
            $display("\nRunning Testcase %03d: Incremental Pattern (0x00-0x3F)", test_num);
            reset_dut();
            for (i = 0; i < 64; i = i + 1) begin
                msg_pattern[(63-i)*8 +: 8] = i[7:0];
            end
            message = msg_pattern;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(output_ready == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(256'h9154f3238622c74d6c6e3b2e59e9a489112a149f05a5f15a31c7c9324022a1f8, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase %03d: Alternating Bits (0x55)", test_num);
            reset_dut();
            message = {64{8'h55}};
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(output_ready == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(256'hbebb802f066e40d859030026e6f4370215e9854746f332c0d519e48792078696, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase %03d: Padded 'abc' String", test_num);
            reset_dut();

            message = 512'h61626380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000018;
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(output_ready == 1'b1);
            @(posedge clk);
            #1;

            check_outputs(256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sha256_hash Testbench");
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
        input [255:0] expected_hash_output;
        input expected_output_ready;
        begin
            if (expected_hash_output === (expected_hash_output ^ hash_output ^ expected_hash_output) &&
                expected_output_ready === (expected_output_ready ^ output_ready ^ expected_output_ready)) begin
                $display("PASS");
                $display("  Outputs: hash_output=%h, output_ready=%b",
                         hash_output, output_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_output=%h, output_ready=%b",
                         expected_hash_output, expected_output_ready);
                $display("  Got:      hash_output=%h, output_ready=%b",
                         hash_output, output_ready);
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
        $dumpvars(0,clk, message, rst, start, hash_output, output_ready);
    end

endmodule
