`timescale 1ns/1ps

module bin_to_bcd_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bin;
    reg clk;
    reg reset;
    wire [3:0] bcd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin_to_bcd dut (
        .bin(bin),
        .clk(clk),
        .reset(reset),
        .bcd(bcd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            bin = 4'b0000;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            bin = 4'd3;
            @(posedge clk);
            #2;
            $display("Test %0d: Input bin=3", test_num);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            bin = 4'd8;
            @(posedge clk);
            #2;
            $display("Test %0d: Input bin=8", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            bin = 4'd9;
            @(posedge clk);
            #2;
            $display("Test %0d: Input bin=9", test_num);
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            bin = 4'd10;
            @(posedge clk);
            #2;
            $display("Test %0d: Input bin=10 (Expect low nibble 0)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            bin = 4'd15;
            @(posedge clk);
            #2;
            $display("Test %0d: Input bin=15 (Expect low nibble 5)", test_num);
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            bin = 4'd0;
            @(posedge clk);
            #2;
            $display("Test %0d: Input bin=0", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            bin = 4'd7;
            @(posedge clk);
            #2;
            reset = 1;
            @(posedge clk);
            #2;
            $display("Test %0d: Reset while input is 7", test_num);
            #1;

            check_outputs(4'd0);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bin_to_bcd Testbench");
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
        input [3:0] expected_bcd;
        begin
            if (expected_bcd === (expected_bcd ^ bcd ^ expected_bcd)) begin
                $display("PASS");
                $display("  Outputs: bcd=%h",
                         bcd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd=%h",
                         expected_bcd);
                $display("  Got:      bcd=%h",
                         bcd);
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
        $dumpvars(0,bin, clk, reset, bcd);
    end

endmodule
