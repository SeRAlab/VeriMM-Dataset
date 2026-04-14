`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg branchID;
    reg memToRegEX;
    reg memToRegMEM;
    reg regWriteEX;
    reg regWriteMEM;
    reg regWriteWB;
    reg [4:0] rsEX;
    reg [4:0] rsID;
    reg [4:0] rtEX;
    reg [4:0] rtID;
    reg [4:0] writeRegEX;
    reg [4:0] writeRegMEM;
    reg [4:0] writeRegWB;
    wire flushEX;
    wire [1:0] forwardAEX;
    wire forwardAID;
    wire [1:0] forwardBEX;
    wire forwardBID;
    wire stallFE;
    wire stallID;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branchID(branchID),
        .memToRegEX(memToRegEX),
        .memToRegMEM(memToRegMEM),
        .regWriteEX(regWriteEX),
        .regWriteMEM(regWriteMEM),
        .regWriteWB(regWriteWB),
        .rsEX(rsEX),
        .rsID(rsID),
        .rtEX(rtEX),
        .rtID(rtID),
        .writeRegEX(writeRegEX),
        .writeRegMEM(writeRegMEM),
        .writeRegWB(writeRegWB),
        .flushEX(flushEX),
        .forwardAEX(forwardAEX),
        .forwardAID(forwardAID),
        .forwardBEX(forwardBEX),
        .forwardBID(forwardBID),
        .stallFE(stallFE),
        .stallID(stallID)
    );
    task testcase001;

        begin
            test_num = 1;

            branchID = 0; rsID = 5'd1; rtID = 5'd2; rsEX = 5'd3; rtEX = 5'd4;
            writeRegEX = 5'd0; writeRegMEM = 5'd0; writeRegWB = 5'd0;
            memToRegEX = 0; memToRegMEM = 0; regWriteEX = 0; regWriteMEM = 0; regWriteWB = 0;


            #1;



            check_outputs(0, 2'b00, 0, 2'b00, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            branchID = 0; rsID = 5'd1; rtID = 5'd2; rsEX = 5'd10; rtEX = 5'd4;
            writeRegEX = 5'd15; writeRegMEM = 5'd10; writeRegWB = 5'd20;
            memToRegEX = 0; regWriteMEM = 1; regWriteWB = 1;


            #1;



            check_outputs(0, 2'b10, 0, 2'b00, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            branchID = 0; rsID = 5'd1; rtID = 5'd2; rsEX = 5'd3; rtEX = 5'd11;
            writeRegEX = 5'd15; writeRegMEM = 5'd11; writeRegWB = 5'd20;
            memToRegEX = 0; regWriteMEM = 1; regWriteWB = 1;


            #1;



            check_outputs(0, 2'b00, 0, 2'b10, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            branchID = 0; rsID = 5'd1; rtID = 5'd2; rsEX = 5'd12; rtEX = 5'd4;
            writeRegEX = 5'd15; writeRegMEM = 5'd25; writeRegWB = 5'd12;
            memToRegEX = 0; regWriteMEM = 1; regWriteWB = 1;


            #1;



            check_outputs(0, 2'b01, 0, 2'b00, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            branchID = 0; rsID = 5'd1; rtID = 5'd2; rsEX = 5'd3; rtEX = 5'd13;
            writeRegEX = 5'd15; writeRegMEM = 5'd25; writeRegWB = 5'd13;
            memToRegEX = 0; regWriteMEM = 1; regWriteWB = 1;


            #1;



            check_outputs(0, 2'b00, 0, 2'b01, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            branchID = 0; rsID = 5'd1; rtID = 5'd2; rsEX = 5'd14; rtEX = 5'd14;
            writeRegMEM = 5'd14; writeRegWB = 5'd14;
            regWriteMEM = 1; regWriteWB = 1;


            #1;



            check_outputs(0, 2'b10, 0, 2'b10, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;

            branchID = 0; rsID = 5'd16; rtID = 5'd2; rsEX = 5'd3; rtEX = 5'd4;
            writeRegEX = 5'd16; memToRegEX = 1; regWriteEX = 1;


            #1;



            check_outputs(1, 2'b00, 0, 2'b00, 0, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;

            branchID = 0; rsID = 5'd1; rtID = 5'd17; rsEX = 5'd3; rtEX = 5'd4;
            writeRegEX = 5'd17; memToRegEX = 1; regWriteEX = 1;


            #1;



            check_outputs(1, 2'b00, 0, 2'b00, 0, 1, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;

            branchID = 1; rsID = 5'd18; rtID = 5'd19; rsEX = 5'd3; rtEX = 5'd4;
            writeRegMEM = 5'd18; regWriteMEM = 1;
            writeRegWB = 5'd19; regWriteWB = 1;



            #1;




            check_outputs(0, 2'b00, 1, 2'b00, 0, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;

            branchID = 1; rsID = 5'd1; rtID = 5'd20;
            writeRegMEM = 5'd20; regWriteMEM = 1;


            #1;



            check_outputs(0, 2'b00, 0, 2'b00, 1, 0, 0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;

            branchID = 1; rsID = 5'd0; rtID = 5'd0; rsEX = 5'd0; rtEX = 5'd0;
            writeRegEX = 5'd0; writeRegMEM = 5'd0; writeRegWB = 5'd0;
            regWriteMEM = 1; regWriteWB = 1; memToRegEX = 1;


            #1;



            check_outputs(0, 2'b00, 0, 2'b00, 0, 0, 0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;

            branchID = 0; rsID = 5'd21; rtID = 5'd2; rsEX = 5'd22; rtEX = 5'd4;
            writeRegEX = 5'd21; memToRegEX = 1;
            writeRegMEM = 5'd22; regWriteMEM = 1;



            #1;




            check_outputs(1, 2'b10, 0, 2'b00, 0, 1, 1);
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
        testcase011();
        testcase012();
        
        
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
        input expected_flushEX;
        input [1:0] expected_forwardAEX;
        input expected_forwardAID;
        input [1:0] expected_forwardBEX;
        input expected_forwardBID;
        input expected_stallFE;
        input expected_stallID;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_flushEX === (expected_flushEX ^ flushEX ^ expected_flushEX) &&
                expected_forwardAEX === (expected_forwardAEX ^ forwardAEX ^ expected_forwardAEX) &&
                expected_forwardAID === (expected_forwardAID ^ forwardAID ^ expected_forwardAID) &&
                expected_forwardBEX === (expected_forwardBEX ^ forwardBEX ^ expected_forwardBEX) &&
                expected_forwardBID === (expected_forwardBID ^ forwardBID ^ expected_forwardBID) &&
                expected_stallFE === (expected_stallFE ^ stallFE ^ expected_stallFE) &&
                expected_stallID === (expected_stallID ^ stallID ^ expected_stallID)) begin
                $display("PASS");
                $display("  Outputs: flushEX=%b, forwardAEX=%h, forwardAID=%b, forwardBEX=%h, forwardBID=%b, stallFE=%b, stallID=%b",
                         flushEX, forwardAEX, forwardAID, forwardBEX, forwardBID, stallFE, stallID);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flushEX=%b, forwardAEX=%h, forwardAID=%b, forwardBEX=%h, forwardBID=%b, stallFE=%b, stallID=%b",
                         expected_flushEX, expected_forwardAEX, expected_forwardAID, expected_forwardBEX, expected_forwardBID, expected_stallFE, expected_stallID);
                $display("  Got:      flushEX=%b, forwardAEX=%h, forwardAID=%b, forwardBEX=%h, forwardBID=%b, stallFE=%b, stallID=%b",
                         flushEX, forwardAEX, forwardAID, forwardBEX, forwardBID, stallFE, stallID);
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
