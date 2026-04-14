`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] objMask;
    reg [7:0] objPos;
    reg [2:0] objSize;
    reg [7:0] pixelNum;
    wire pixelOn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .objMask(objMask),
        .objPos(objPos),
        .objSize(objSize),
        .pixelNum(pixelNum),
        .pixelOn(pixelOn)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Starting position hit", test_num);
        pixelNum = 8'd50;
        objPos   = 8'd50;
        objSize  = 3'd3;
        objMask  = 8'h01;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Mask boundary hit (Index 7)", test_num);
        pixelNum = 8'd57;
        objPos   = 8'd50;
        objSize  = 3'd3;
        objMask  = 8'h80;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Mask bit miss", test_num);
        pixelNum = 8'd52;
        objPos   = 8'd50;
        objSize  = 3'd3;
        objMask  = 8'hFB;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Outside range (High)", test_num);
        pixelNum = 8'd58;
        objPos   = 8'd50;
        objSize  = 3'd3;
        objMask  = 8'hFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Outside range (Low)", test_num);
        pixelNum = 8'd49;
        objPos   = 8'd50;
        objSize  = 3'd3;
        objMask  = 8'hFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Size constraint miss (Size=2, Index=4)", test_num);
        pixelNum = 8'd54;
        objPos   = 8'd50;
        objSize  = 3'd2;
        objMask  = 8'hFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Small size hit (Size=1, Index=1)", test_num);
        pixelNum = 8'd51;
        objPos   = 8'd50;
        objSize  = 3'd1;
        objMask  = 8'h02;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: High boundary hit (Pixel 255)", test_num);
        pixelNum = 8'd255;
        objPos   = 8'd250;
        objSize  = 3'd3;
        objMask  = 8'h20;
        #1;

        check_outputs(1'b1);
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
        input expected_pixelOn;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pixelOn === (expected_pixelOn ^ pixelOn ^ expected_pixelOn)) begin
                $display("PASS");
                $display("  Outputs: pixelOn=%b",
                         pixelOn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixelOn=%b",
                         expected_pixelOn);
                $display("  Got:      pixelOn=%b",
                         pixelOn);
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
