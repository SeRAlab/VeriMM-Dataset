`timescale 1ns/1ps

module bin2gray_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bin;
    reg clk;
    wire [3:0] gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin2gray dut (
        .bin(bin),
        .clk(clk),
        .gray(gray)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        bin <= 4'b0000;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Binary 0000");
        reset_dut();
        test_num = 1;
        bin <= 4'b0000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Binary 0001");
        reset_dut();
        test_num = 2;
        bin <= 4'b0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Binary 0010");
        reset_dut();
        test_num = 3;
        bin <= 4'b0010;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Binary 0100");
        reset_dut();
        test_num = 4;
        bin <= 4'b0100;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Binary 1000");
        reset_dut();
        test_num = 5;
        bin <= 4'b1000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase006;

    begin
        $display("Running Testcase 006: Binary 1111");
        reset_dut();
        test_num = 6;
        bin <= 4'b1111;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase007;

    begin
        $display("Running Testcase 007: Binary 1010");
        reset_dut();
        test_num = 7;
        bin <= 4'b1010;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase008;

    begin
        $display("Running Testcase 008: Binary 0111");
        reset_dut();
        test_num = 8;
        bin <= 4'b0111;
        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin2gray Testbench");
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
        input [3:0] expected_gray;
        begin
            if (expected_gray === (expected_gray ^ gray ^ expected_gray)) begin
                $display("PASS");
                $display("  Outputs: gray=%h",
                         gray);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray=%h",
                         expected_gray);
                $display("  Got:      gray=%h",
                         gray);
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
        $dumpvars(0,bin, clk, gray);
    end

endmodule
