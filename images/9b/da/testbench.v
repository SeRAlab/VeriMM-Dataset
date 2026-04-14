`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] BWD;
    reg EXTDATA;
    reg NOT_DEI;
    reg [31:0] SRC;
    wire [31:0] DOUT;
    wire MINUS;
    wire [4:0] MSB;
    wire NULL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BWD(BWD),
        .EXTDATA(EXTDATA),
        .NOT_DEI(NOT_DEI),
        .SRC(SRC),
        .DOUT(DOUT),
        .MINUS(MINUS),
        .MSB(MSB),
        .NULL(NULL)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        BWD = 2'b00; EXTDATA = 1'b0; NOT_DEI = 1'b0; SRC = 32'hFFFF_FF45;

        #1;


        check_outputs(32'h00000045, 1'b0, 5'd6, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        BWD = 2'b00; EXTDATA = 1'b1; NOT_DEI = 1'b0; SRC = 32'h0000_0082;

        #1;


        check_outputs(32'hFFFFFF82, 1'b1, 5'd7, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        BWD = 2'b00; EXTDATA = 1'b0; NOT_DEI = 1'b0; SRC = 32'hFFFF_FF00;

        #1;


        check_outputs(32'h00000000, 1'b0, 5'd0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        BWD = 2'b01; EXTDATA = 1'b0; NOT_DEI = 1'b0; SRC = 32'hFFFF_1234;

        #1;


        check_outputs(32'h00001234, 1'b0, 5'd12, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        BWD = 2'b01; EXTDATA = 1'b1; NOT_DEI = 1'b0; SRC = 32'h0000_8005;

        #1;


        check_outputs(32'hFFFF8005, 1'b1, 5'd15, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        BWD = 2'b10; EXTDATA = 1'b0; NOT_DEI = 1'b0; SRC = 32'h000F_0000;

        #1;


        check_outputs(32'h000F0000, 1'b0, 5'd19, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        BWD = 2'b10; EXTDATA = 1'b0; NOT_DEI = 1'b0; SRC = 32'h8000_0001;

        #1;


        check_outputs(32'h80000001, 1'b1, 5'd31, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        BWD = 2'b10; EXTDATA = 1'b0; NOT_DEI = 1'b0; SRC = 32'h0000_0000;

        #1;


        check_outputs(32'h00000000, 1'b0, 5'd0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        BWD = 2'b00; EXTDATA = 1'b0; NOT_DEI = 1'b0; SRC = 32'h0000_0001;

        #1;


        check_outputs(32'h00000001, 1'b0, 5'd0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        BWD = 2'b10; EXTDATA = 1'b0; NOT_DEI = 1'b1; SRC = 32'h1234_5678;


        #1;



        check_outputs(32'h00000000, 1'b0, 5'd0, 1'b1);
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
        input [31:0] expected_DOUT;
        input expected_MINUS;
        input [4:0] expected_MSB;
        input expected_NULL;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT) &&
                expected_MINUS === (expected_MINUS ^ MINUS ^ expected_MINUS) &&
                expected_MSB === (expected_MSB ^ MSB ^ expected_MSB) &&
                expected_NULL === (expected_NULL ^ NULL ^ expected_NULL)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h, MINUS=%b, MSB=%h, NULL=%b",
                         DOUT, MINUS, MSB, NULL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h, MINUS=%b, MSB=%h, NULL=%b",
                         expected_DOUT, expected_MINUS, expected_MSB, expected_NULL);
                $display("  Got:      DOUT=%h, MINUS=%b, MSB=%h, NULL=%b",
                         DOUT, MINUS, MSB, NULL);
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
