`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] B;
    reg clk;
    wire [1:0] LZ;
    wire [3:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .clk(clk),
        .LZ(LZ),
        .R(R)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            B = 4'b0000;
            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            B = 4'b1111;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: B=1111 (Full bits)", test_num);
            #1;

            check_outputs(2'd0, 4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            B = 4'b0001;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: B=0001 (R=1000)", test_num);
            #1;

            check_outputs(2'd0, 4'b1000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            B = 4'b0010;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: B=0010 (R=0100)", test_num);
            #1;

            check_outputs(2'd1, 4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            B = 4'b0100;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: B=0100 (R=0010)", test_num);
            #1;

            check_outputs(2'd2, 4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            B = 4'b1000;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: B=1000 (R=0001)", test_num);
            #1;

            check_outputs(2'd3, 4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            B = 4'b0000;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: B=0000 (All zeros)", test_num);
            #1;

            check_outputs(2'd3, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            B = 4'b1010;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: B=1010 (R=0101)", test_num);
            #1;

            check_outputs(2'd1, 4'b0101);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            B = 4'b1100;
            repeat(2) @(posedge clk);
            #1;
            $display("Test %0d: B=1100 (R=0011)", test_num);
            #1;

            check_outputs(2'd2, 4'b0011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [1:0] expected_LZ;
        input [3:0] expected_R;
        begin
            if (expected_LZ === (expected_LZ ^ LZ ^ expected_LZ) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: LZ=%h, R=%h",
                         LZ, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LZ=%h, R=%h",
                         expected_LZ, expected_R);
                $display("  Got:      LZ=%h, R=%h",
                         LZ, R);
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
        $dumpvars(0,B, clk, LZ, R);
    end

endmodule
