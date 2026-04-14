`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg [15:0] DATA_IN_PINS;
    reg [15:0] address;
    reg [15:0] dataIn;
    reg write;
    wire [15:0] ADDRESS_PINS;
    wire CE;
    wire [15:0] DATA_OUT_PINS;
    wire LB;
    wire OE;
    wire UB;
    wire WR;
    wire [15:0] dataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA_IN_PINS(DATA_IN_PINS),
        .address(address),
        .dataIn(dataIn),
        .write(write),
        .ADDRESS_PINS(ADDRESS_PINS),
        .CE(CE),
        .DATA_OUT_PINS(DATA_OUT_PINS),
        .LB(LB),
        .OE(OE),
        .UB(UB),
        .WR(WR),
        .dataOut(dataOut)
    );
    task testcase001;

        begin
            test_num = 1;

            CLK = 0;
            address = 16'h0000;
            dataIn = 16'h0000;
            write = 0;
            DATA_IN_PINS = 16'h0000;
            #10;


            address = 16'h1001;
            dataIn = 16'hAAAA;
            write = 1;
            DATA_IN_PINS = 16'h0000;


            #5; CLK = 1; #5; CLK = 0; #5;



            #1;




            check_outputs(16'h1001, 1'b0, 16'hAAAA, 1'b0, 1'b1, 1'b0, 1'b0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            CLK = 0;
            address = 16'h0000;
            dataIn = 16'h0000;
            write = 0;
            DATA_IN_PINS = 16'h0000;
            #10;



            address = 16'h2002;
            write = 0;
            DATA_IN_PINS = 16'h5555;

            #5; CLK = 1; #5; CLK = 0; #5;



            #1;




            check_outputs(16'h2002, 1'b0, 16'h0000, 1'b0, 1'b0, 1'b0, 1'b1, 16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            CLK = 0;
            #10;


            address = 16'hFFFF;
            dataIn = 16'h1234;
            write = 1;

            #5; CLK = 1; #5; CLK = 0; #5;

            #1;


            check_outputs(16'hFFFF, 1'b0, 16'h1234, 1'b0, 1'b1, 1'b0, 1'b0, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            CLK = 0;
            #10;


            address = 16'h0000;
            write = 0;
            DATA_IN_PINS = 16'hABCD;

            #5; CLK = 1; #5; CLK = 0; #5;

            #1;


            check_outputs(16'h0000, 1'b0, 16'h0000, 1'b0, 1'b0, 1'b0, 1'b1, 16'hABCD);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            CLK = 0;
            #10;


            address = 16'h8000;
            dataIn = 16'hF0F0;
            write = 1;

            #5; CLK = 1; #5; CLK = 0; #5;

            #1;


            check_outputs(16'h8000, 1'b0, 16'hF0F0, 1'b0, 1'b1, 1'b0, 1'b0, 16'h0000);
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
        input [15:0] expected_ADDRESS_PINS;
        input expected_CE;
        input [15:0] expected_DATA_OUT_PINS;
        input expected_LB;
        input expected_OE;
        input expected_UB;
        input expected_WR;
        input [15:0] expected_dataOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ADDRESS_PINS === (expected_ADDRESS_PINS ^ ADDRESS_PINS ^ expected_ADDRESS_PINS) &&
                expected_CE === (expected_CE ^ CE ^ expected_CE) &&
                expected_DATA_OUT_PINS === (expected_DATA_OUT_PINS ^ DATA_OUT_PINS ^ expected_DATA_OUT_PINS) &&
                expected_LB === (expected_LB ^ LB ^ expected_LB) &&
                expected_OE === (expected_OE ^ OE ^ expected_OE) &&
                expected_UB === (expected_UB ^ UB ^ expected_UB) &&
                expected_WR === (expected_WR ^ WR ^ expected_WR) &&
                expected_dataOut === (expected_dataOut ^ dataOut ^ expected_dataOut)) begin
                $display("PASS");
                $display("  Outputs: ADDRESS_PINS=%h, CE=%b, DATA_OUT_PINS=%h, LB=%b, OE=%b, UB=%b, WR=%b, dataOut=%h",
                         ADDRESS_PINS, CE, DATA_OUT_PINS, LB, OE, UB, WR, dataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ADDRESS_PINS=%h, CE=%b, DATA_OUT_PINS=%h, LB=%b, OE=%b, UB=%b, WR=%b, dataOut=%h",
                         expected_ADDRESS_PINS, expected_CE, expected_DATA_OUT_PINS, expected_LB, expected_OE, expected_UB, expected_WR, expected_dataOut);
                $display("  Got:      ADDRESS_PINS=%h, CE=%b, DATA_OUT_PINS=%h, LB=%b, OE=%b, UB=%b, WR=%b, dataOut=%h",
                         ADDRESS_PINS, CE, DATA_OUT_PINS, LB, OE, UB, WR, dataOut);
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
