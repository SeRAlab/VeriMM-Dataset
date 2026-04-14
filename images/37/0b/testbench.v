`timescale 1ns/1ps

module jpeg_compression_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] pixel_values;
    reg rst;
    wire [63:0] compressed_values;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jpeg_compression dut (
        .clk(clk),
        .pixel_values(pixel_values),
        .rst(rst),
        .compressed_values(compressed_values)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            pixel_values = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            pixel_values = 64'h0000000000000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            pixel_values = 64'h1010101010101010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0202020202020202);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            pixel_values = 64'h0B0B0B0B0B0B0B0B;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0101010101010101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            pixel_values = 64'h0C0C0C0C0C0C0C0C;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0202020202020202);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            pixel_values = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h2020202020202020);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            pixel_values = 64'h1C1814100C080400;
            @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0403030202010100);
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
        input [63:0] expected_compressed_values;
        begin
            if (expected_compressed_values === (expected_compressed_values ^ compressed_values ^ expected_compressed_values)) begin
                $display("PASS");
                $display("  Outputs: compressed_values=%h",
                         compressed_values);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_values=%h",
                         expected_compressed_values);
                $display("  Got:      compressed_values=%h",
                         compressed_values);
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
        $dumpvars(0,clk, pixel_values, rst, compressed_values);
    end

endmodule
