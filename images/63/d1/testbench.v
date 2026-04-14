`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] ADDR_bus_in;
    reg [19:0] CNTRL_bus_in;
    reg [15:0] DATA_bus_in;
    wire [3:0] FLAG_bus_out;
    wire [15:0] FU_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR_bus_in(ADDR_bus_in),
        .CNTRL_bus_in(CNTRL_bus_in),
        .DATA_bus_in(DATA_bus_in),
        .FLAG_bus_out(FLAG_bus_out),
        .FU_out(FU_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition (A + B)", test_num);
        ADDR_bus_in = 16'h0005;
        DATA_bus_in = 16'h000A;
        CNTRL_bus_in = 20'h0008;
        #10;

        #1;


        check_outputs(4'b0000, 16'h000F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with Carry and Zero", test_num);
        ADDR_bus_in = 16'hFFFF;
        DATA_bus_in = 16'h0001;
        CNTRL_bus_in = 20'h0008;
        #10;

        #1;


        check_outputs(4'b0101, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction (A - B)", test_num);
        ADDR_bus_in = 16'h0020;
        DATA_bus_in = 16'h0005;
        CNTRL_bus_in = 20'h0014;
        #10;

        #1;


        check_outputs(4'b0100, 16'h001B);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction resulting in Negative", test_num);
        ADDR_bus_in = 16'h0002;
        DATA_bus_in = 16'h0005;
        CNTRL_bus_in = 20'h0014;
        #10;

        #1;


        check_outputs(4'b0010, 16'hFFFD);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arithmetic Overflow (V flag)", test_num);
        ADDR_bus_in = 16'h7000;
        DATA_bus_in = 16'h1000;
        CNTRL_bus_in = 20'h0008;
        #10;

        #1;


        check_outputs(4'b1010, 16'h8000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise AND", test_num);
        ADDR_bus_in = 16'hF0F0;
        DATA_bus_in = 16'hAAAA;
        CNTRL_bus_in = 20'h0020;
        #10;

        #1;


        check_outputs(4'b0010, 16'hA0A0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bitwise OR", test_num);
        ADDR_bus_in = 16'h1234;
        DATA_bus_in = 16'h8000;
        CNTRL_bus_in = 20'h0028;
        #10;

        #1;


        check_outputs(4'b0010, 16'h9234);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Logical Shift Left", test_num);
        ADDR_bus_in = 16'h0000;
        DATA_bus_in = 16'h0001;
        CNTRL_bus_in = 20'h0038;
        #10;

        #1;


        check_outputs(4'b0000, 16'h0002);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Logical Shift Right", test_num);
        ADDR_bus_in = 16'h0000;
        DATA_bus_in = 16'h0002;
        CNTRL_bus_in = 20'h0034;
        #10;

        #1;


        check_outputs(4'b0000, 16'h0001);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Transfer ADDR_bus_in", test_num);
        ADDR_bus_in = 16'hABCD;
        DATA_bus_in = 16'h1234;
        CNTRL_bus_in = 20'h0000;
        #10;

        #1;


        check_outputs(4'b0010, 16'hABCD);
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_FLAG_bus_out;
        input [15:0] expected_FU_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_FLAG_bus_out === (expected_FLAG_bus_out ^ FLAG_bus_out ^ expected_FLAG_bus_out) &&
                expected_FU_out === (expected_FU_out ^ FU_out ^ expected_FU_out)) begin
                $display("PASS");
                $display("  Outputs: FLAG_bus_out=%h, FU_out=%h",
                         FLAG_bus_out, FU_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FLAG_bus_out=%h, FU_out=%h",
                         expected_FLAG_bus_out, expected_FU_out);
                $display("  Got:      FLAG_bus_out=%h, FU_out=%h",
                         FLAG_bus_out, FU_out);
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

endmodule
