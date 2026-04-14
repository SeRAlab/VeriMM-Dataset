`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [12:0] A;
    reg [12:0] B;
    reg clk;
    wire [26:0] Y;
    wire [26:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .Y(Y),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        A <= 13'd0;
        B <= 13'd0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 13'd0; B <= 13'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(27'd0, 27'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 13'd1; B <= 13'd1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(27'd1, 27'h7FFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 13'd10; B <= 13'd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(27'd50, 27'h7FFFFCE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 13'h1FFF; B <= 13'd1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(27'd8191, 27'h7FFE001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 13'h1FFF; B <= 13'h1FFF;
        @(posedge clk);
        #1;

        #1;


        check_outputs(27'h3FF8001, 27'h4007FFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 13'd1234; B <= 13'd5678;
        @(posedge clk);
        #1;

        #1;


        check_outputs(27'h06AE9BC, 27'h7951644);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 13'h1000; B <= 13'd2;
        @(posedge clk);
        #1;
        #1;

        check_outputs(27'h0002000, 27'h7FFE000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        reset_dut();
        A <= 13'h1555; B <= 13'h0AAA;
        @(posedge clk);
        #1;

        #1;


        check_outputs(27'h0E3838E, 27'h71C7C72);
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
        input [26:0] expected_Y;
        input [26:0] expected_Z;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Y=%h, Z=%h",
                         Y, Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h, Z=%h",
                         expected_Y, expected_Z);
                $display("  Got:      Y=%h, Z=%h",
                         Y, Z);
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
        $dumpvars(0,A, B, clk, Y, Z);
    end

endmodule
