`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [79:0] A;
    reg [15:0] B;
    reg clk;
    reg sof;
    wire [179:0] C;
    wire [4:0] valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .sof(sof),
        .C(C),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sof = 0;
            A = 0;
            B = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A = 80'h1;
            B = 16'h1;
            sof = 1;
            @(posedge clk);
            sof = 0;
            repeat(2) @(posedge clk);


            #1;



            check_outputs(180'h1000000, 5'h1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 80'd5;
            B = 16'd10;
            sof = 1;
            @(posedge clk);
            sof = 0;
            repeat(2) @(posedge clk);

            #1;


            check_outputs(180'h32000000, 5'h1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 80'h0;
            B = 16'hFFFF;
            sof = 1;
            @(posedge clk);
            sof = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(180'h0, 5'h1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 80'hABCDE;
            B = 16'h0;
            sof = 1;
            @(posedge clk);
            sof = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(180'h0, 5'h1);
        end
        endtask

    task testcase005;

        reg [179:0] expected;
        begin
            reset_dut();
            test_num = 5;
            A = {80{1'b1}};
            B = 16'h1;
            sof = 1;
            @(posedge clk);
            sof = 0;
            repeat(2) @(posedge clk);
            expected = (180'hFFFFFFFFFFFFFFFFFFFF << 24);
            #1;

            check_outputs(expected, 5'h1);
        end
        endtask

    task testcase006;

        reg [179:0] expected;
        begin
            reset_dut();
            test_num = 6;
            A = 80'h1;
            B = 16'hFFFF;
            sof = 1;
            @(posedge clk);
            sof = 0;
            repeat(2) @(posedge clk);
            expected = (180'h1 << 24) * 16'hFFFF;
            #1;

            check_outputs(expected, 5'h1);
        end
        endtask

    task testcase007;

        reg [179:0] expected;
        begin
            reset_dut();
            test_num = 7;
            A = 80'h1234567890ABCDE;
            B = 16'hF0F0;
            sof = 1;
            @(posedge clk);
            sof = 0;
            repeat(2) @(posedge clk);
            expected = (180'h1234567890ABCDE << 24) * 16'hF0F0;
            #1;

            check_outputs(expected, 5'h1);
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
        input [179:0] expected_C;
        input [4:0] expected_valid;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: C=%h, valid=%h",
                         C, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, valid=%h",
                         expected_C, expected_valid);
                $display("  Got:      C=%h, valid=%h",
                         C, valid);
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
        $dumpvars(0,A, B, clk, sof, C, valid);
    end

endmodule
