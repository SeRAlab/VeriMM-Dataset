`timescale 1ns/1ps

module RB_cnt_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] B;
    reg [63:0] R;
    reg RST;
    reg clk;
    wire [6:0] cntB;
    wire [6:0] cntR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RB_cnt dut (
        .B(B),
        .R(R),
        .RST(RST),
        .clk(clk),
        .cntB(cntB),
        .cntR(cntR)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        RST = 1;
        B = 0;
        R = 0;
        @(posedge clk);
        #1;
        RST = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: All Zeros", test_num);
        reset_dut();
        B = 64'h0;
        R = 64'h0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(7'd0, 7'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: All Ones", test_num);
        reset_dut();
        B = 64'hFFFFFFFFFFFFFFFF;
        R = 64'hFFFFFFFFFFFFFFFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(7'd64, 7'd64);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Single Bit (LSB and MSB)", test_num);
        reset_dut();
        B = 64'h0000000000000001;
        R = 64'h8000000000000000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(7'd1, 7'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Checkerboard Pattern (32 bits)", test_num);
        reset_dut();
        B = 64'h5555555555555555;
        R = 64'hAAAAAAAAAAAAAAAA;
        @(posedge clk);
        #2;
        #1;

        check_outputs(7'd32, 7'd32);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Sparse Density", test_num);
        reset_dut();
        B = 64'h123456789ABCDEF0;


        R = 64'h00000000FFFF0000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(7'd32, 7'd16);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Reset during operation", test_num);
        reset_dut();
        B = 64'hFFFFFFFFFFFFFFFF;
        R = 64'hFFFFFFFFFFFFFFFF;
        @(posedge clk);
        #1;
        RST = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(7'd0, 7'd0);
        RST = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RB_cnt Testbench");
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
        input [6:0] expected_cntB;
        input [6:0] expected_cntR;
        begin
            if (expected_cntB === (expected_cntB ^ cntB ^ expected_cntB) &&
                expected_cntR === (expected_cntR ^ cntR ^ expected_cntR)) begin
                $display("PASS");
                $display("  Outputs: cntB=%h, cntR=%h",
                         cntB, cntR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cntB=%h, cntR=%h",
                         expected_cntB, expected_cntR);
                $display("  Got:      cntB=%h, cntR=%h",
                         cntB, cntR);
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
        $dumpvars(0,B, R, RST, clk, cntB, cntR);
    end

endmodule
