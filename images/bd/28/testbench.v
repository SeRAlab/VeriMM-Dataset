`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg doShuf;
    reg [1:0] idxDfl;
    reg [1:0] idxShuf;
    reg [31:0] regValA;
    reg [31:0] regValB;
    reg [31:0] regValC;
    reg [31:0] regValD;
    wire [31:0] regOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .doShuf(doShuf),
        .idxDfl(idxDfl),
        .idxShuf(idxShuf),
        .regValA(regValA),
        .regValB(regValB),
        .regValC(regValC),
        .regValD(regValD),
        .regOut(regOut)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Default Mode (doShuf=0) - Select All Inputs", test_num);
            regValA = 32'h1111_1111;
            regValB = 32'h2222_2222;
            regValC = 32'h3333_3333;
            regValD = 32'h4444_4444;
            doShuf = 1'b0;
            idxShuf = 2'b11;


            idxDfl = 2'b00;
            #1;

            check_outputs(32'h1111_1111);


            idxDfl = 2'b01;
            #1;

            check_outputs(32'h2222_2222);


            idxDfl = 2'b10;
            #1;

            check_outputs(32'h3333_3333);


            idxDfl = 2'b11;
            #1;

            check_outputs(32'h4444_4444);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shuffle Mode (doShuf=1) - Select All Inputs", test_num);
            regValA = 32'hAAAA_AAAA;
            regValB = 32'hBBBB_BBBB;
            regValC = 32'hCCCC_CCCC;
            regValD = 32'hDDDD_DDDD;
            doShuf = 1'b1;
            idxDfl = 2'b00;


            idxShuf = 2'b00;
            #1;

            check_outputs(32'hAAAA_AAAA);


            idxShuf = 2'b01;
            #1;

            check_outputs(32'hBBBB_BBBB);


            idxShuf = 2'b10;
            #1;

            check_outputs(32'hCCCC_CCCC);


            idxShuf = 2'b11;
            #1;

            check_outputs(32'hDDDD_DDDD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Switch doShuf bit and check isolation", test_num);
            regValA = 32'hDEAF_BEEF;
            regValB = 32'hFEED_FACE;
            regValC = 32'h1234_5678;
            regValD = 32'h8765_4321;

            idxDfl = 2'b01;
            idxShuf = 2'b10;


            doShuf = 1'b0;
            #1;

            check_outputs(32'hFEED_FACE);


            doShuf = 1'b1;
            #1;

            check_outputs(32'h1234_5678);


            idxDfl = 2'b00;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify data propagation through selected path", test_num);
            doShuf = 1'b0;
            idxDfl = 2'b11;
            idxShuf = 2'b00;

            regValD = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0001);

            regValD = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFF);

            regValD = 32'hA5A5_5A5A;
            #1;

            check_outputs(32'hA5A5_5A5A);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Rapid mode and index toggling", test_num);
            regValA = 32'h0; regValB = 32'h1; regValC = 32'h2; regValD = 32'h3;

            doShuf = 1'b1; idxShuf = 2'b00; #1;
            doShuf = 1'b0; idxDfl = 2'b11;  #1;
            doShuf = 1'b1; idxShuf = 2'b10; #1;
            doShuf = 1'b0; idxDfl = 2'b01;  #1;


            #1;



            check_outputs(32'h1);
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
        input [31:0] expected_regOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_regOut === (expected_regOut ^ regOut ^ expected_regOut)) begin
                $display("PASS");
                $display("  Outputs: regOut=%h",
                         regOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: regOut=%h",
                         expected_regOut);
                $display("  Got:      regOut=%h",
                         regOut);
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
