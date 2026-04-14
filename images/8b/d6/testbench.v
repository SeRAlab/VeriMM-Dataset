`timescale 1ns/1ps

module bin2bcd_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] bin_in;
    reg clk;
    reg rst_n;
    wire [11:0] bcd_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin2bcd dut (
        .bin_in(bin_in),
        .clk(clk),
        .rst_n(rst_n),
        .bcd_out(bcd_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            bin_in = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 0", test_num);
            reset_dut();
            bin_in = 8'd0;

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 255", test_num);
            reset_dut();
            bin_in = 8'd255;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 9", test_num);
            reset_dut();
            bin_in = 8'd9;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h009);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 99", test_num);
            reset_dut();
            bin_in = 8'd99;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h099);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 100", test_num);
            reset_dut();
            bin_in = 8'd100;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 123", test_num);
            reset_dut();
            bin_in = 8'd123;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h123);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Binary Input = 170", test_num);
            reset_dut();
            bin_in = 8'd170;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h170);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset behavior check", test_num);
            reset_dut();
            bin_in = 8'd200;
            @(posedge clk);
            rst_n = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin2bcd Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [11:0] expected_bcd_out;
        begin
            if (expected_bcd_out === (expected_bcd_out ^ bcd_out ^ expected_bcd_out)) begin
                $display("PASS");
                $display("  Outputs: bcd_out=%h",
                         bcd_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_out=%h",
                         expected_bcd_out);
                $display("  Got:      bcd_out=%h",
                         bcd_out);
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
        $dumpvars(0,bin_in, clk, rst_n, bcd_out);
    end

endmodule
