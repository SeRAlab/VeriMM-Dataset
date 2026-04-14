`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg PixelClk_I;
    reg [23:0] vid_pData_I;
    reg vid_pHSync_I;
    reg vid_pVDE_I;
    reg vid_pVSync_I;
    wire PixelClk_O;
    wire [23:0] vid_pData_O;
    wire vid_pHSync_O;
    wire vid_pVDE_O;
    wire vid_pVSync_O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PixelClk_I(PixelClk_I),
        .vid_pData_I(vid_pData_I),
        .vid_pHSync_I(vid_pHSync_I),
        .vid_pVDE_I(vid_pVDE_I),
        .vid_pVSync_I(vid_pVSync_I),
        .PixelClk_O(PixelClk_O),
        .vid_pData_O(vid_pData_O),
        .vid_pHSync_O(vid_pHSync_O),
        .vid_pVDE_O(vid_pVDE_O),
        .vid_pVSync_O(vid_pVSync_O)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Standard Active Video Data", test_num);

            PixelClk_I   = 1'b1;
            vid_pData_I  = 24'hFF00AA;
            vid_pHSync_I = 1'b0;
            vid_pVSync_I = 1'b0;
            vid_pVDE_I   = 1'b1;

            #10;

            #1;


            check_outputs(1'b1, 24'hFF00AA, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Horizontal Sync Active (Blanking)", test_num);

            PixelClk_I   = 1'b0;
            vid_pData_I  = 24'h000000;
            vid_pHSync_I = 1'b1;
            vid_pVSync_I = 1'b0;
            vid_pVDE_I   = 1'b0;

            #10;

            #1;


            check_outputs(1'b0, 24'h000000, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Vertical Sync Active", test_num);

            PixelClk_I   = 1'b1;
            vid_pData_I  = 24'h000000;
            vid_pHSync_I = 1'b0;
            vid_pVSync_I = 1'b1;
            vid_pVDE_I   = 1'b0;

            #10;

            #1;


            check_outputs(1'b1, 24'h000000, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Change with Clock Toggle", test_num);

            PixelClk_I   = 1'b0;
            vid_pData_I  = 24'h123456;
            vid_pHSync_I = 1'b0;
            vid_pVSync_I = 1'b0;
            vid_pVDE_I   = 1'b1;

            #5;
            PixelClk_I   = 1'b1;
            vid_pData_I  = 24'h654321;
            #5;


            #1;



            check_outputs(1'b1, 24'h654321, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Scale Signals", test_num);

            PixelClk_I   = 1'b1;
            vid_pData_I  = 24'hFFFFFF;
            vid_pHSync_I = 1'b1;
            vid_pVSync_I = 1'b1;
            vid_pVDE_I   = 1'b1;

            #10;

            #1;


            check_outputs(1'b1, 24'hFFFFFF, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Signals Low", test_num);

            PixelClk_I   = 1'b0;
            vid_pData_I  = 24'h000000;
            vid_pHSync_I = 1'b0;
            vid_pVSync_I = 1'b0;
            vid_pVDE_I   = 1'b0;

            #10;

            #1;


            check_outputs(1'b0, 24'h000000, 1'b0, 1'b0, 1'b0);
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
        input expected_PixelClk_O;
        input [23:0] expected_vid_pData_O;
        input expected_vid_pHSync_O;
        input expected_vid_pVDE_O;
        input expected_vid_pVSync_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PixelClk_O === (expected_PixelClk_O ^ PixelClk_O ^ expected_PixelClk_O) &&
                expected_vid_pData_O === (expected_vid_pData_O ^ vid_pData_O ^ expected_vid_pData_O) &&
                expected_vid_pHSync_O === (expected_vid_pHSync_O ^ vid_pHSync_O ^ expected_vid_pHSync_O) &&
                expected_vid_pVDE_O === (expected_vid_pVDE_O ^ vid_pVDE_O ^ expected_vid_pVDE_O) &&
                expected_vid_pVSync_O === (expected_vid_pVSync_O ^ vid_pVSync_O ^ expected_vid_pVSync_O)) begin
                $display("PASS");
                $display("  Outputs: PixelClk_O=%b, vid_pData_O=%h, vid_pHSync_O=%b, vid_pVDE_O=%b, vid_pVSync_O=%b",
                         PixelClk_O, vid_pData_O, vid_pHSync_O, vid_pVDE_O, vid_pVSync_O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PixelClk_O=%b, vid_pData_O=%h, vid_pHSync_O=%b, vid_pVDE_O=%b, vid_pVSync_O=%b",
                         expected_PixelClk_O, expected_vid_pData_O, expected_vid_pHSync_O, expected_vid_pVDE_O, expected_vid_pVSync_O);
                $display("  Got:      PixelClk_O=%b, vid_pData_O=%h, vid_pHSync_O=%b, vid_pVDE_O=%b, vid_pVSync_O=%b",
                         PixelClk_O, vid_pData_O, vid_pHSync_O, vid_pVDE_O, vid_pVSync_O);
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
