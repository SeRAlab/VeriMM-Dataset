`timescale 1ns/1ps

module jpeg_compression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] pixel_data;
    reg rst;
    reg valid;
    wire [127:0] compressed_data;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jpeg_compression dut (
        .clk(clk),
        .pixel_data(pixel_data),
        .rst(rst),
        .valid(valid),
        .compressed_data(compressed_data),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid = 0;
            pixel_data = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All identical pixels", test_num);
            reset_dut();
            pixel_data = 64'hAAAAAAAAAAAAAAAA;
            valid = 1;
            @(posedge clk);
            valid = 0;


            wait(valid_out);
            @(posedge clk);
            #1;

            check_outputs(128'h08AA_0000_0000_0000_0000_0000_0000_0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All different pixels", test_num);
            reset_dut();
            pixel_data = 64'h0102030405060708;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(valid_out);
            @(posedge clk);
            #1;

            check_outputs(128'h01010102010301040105010601070108, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Two distinct runs", test_num);
            reset_dut();
            pixel_data = 64'hFFFFFFFF00000000;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(valid_out);
            @(posedge clk);
            #1;

            check_outputs(128'h04FF0400000000000000000000000000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating pixels", test_num);
            reset_dut();
            pixel_data = 64'hA1B2A1B2A1B2A1B2;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(valid_out);
            @(posedge clk);
            #1;

            check_outputs(128'h01A101B201A101B201A101B201A101B2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Varied run lengths", test_num);
            reset_dut();
            pixel_data = 64'h555555AABBBBBBBB;
            valid = 1;
            @(posedge clk);
            valid = 0;

            wait(valid_out);
            @(posedge clk);
            #1;

            check_outputs(128'h035501AA04BB00000000000000000000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("jpeg_compression Testbench");
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
        input [127:0] expected_compressed_data;
        input expected_valid_out;
        begin
            if (expected_compressed_data === (expected_compressed_data ^ compressed_data ^ expected_compressed_data) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: compressed_data=%h, valid_out=%b",
                         compressed_data, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_data=%h, valid_out=%b",
                         expected_compressed_data, expected_valid_out);
                $display("  Got:      compressed_data=%h, valid_out=%b",
                         compressed_data, valid_out);
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
        $dumpvars(0,clk, pixel_data, rst, valid, compressed_data, valid_out);
    end

endmodule
