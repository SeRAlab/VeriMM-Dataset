`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] WrtBackData;
    reg [31:0] extImm;
    reg fwRs;
    reg fwRt;
    reg [31:0] rsd;
    reg [31:0] rtd;
    reg sel_imm;
    reg sel_shamt;
    reg [4:0] shamt;
    wire [31:0] FwRsd;
    wire [31:0] FwRtd;
    wire [31:0] busA;
    wire [31:0] busB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .WrtBackData(WrtBackData),
        .extImm(extImm),
        .fwRs(fwRs),
        .fwRt(fwRt),
        .rsd(rsd),
        .rtd(rtd),
        .sel_imm(sel_imm),
        .sel_shamt(sel_shamt),
        .shamt(shamt),
        .FwRsd(FwRsd),
        .FwRtd(FwRtd),
        .busA(busA),
        .busB(busB)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No forwarding, no selection (Base Case)", test_num);
            rsd = 32'hAAAA_AAAA;
            rtd = 32'hBBBB_BBBB;
            WrtBackData = 32'hCCCC_CCCC;
            extImm = 32'hDDDD_DDDD;
            shamt = 5'h1F;
            fwRs = 0;
            fwRt = 0;
            sel_shamt = 0;
            sel_imm = 0;


            #1;



            check_outputs(32'hAAAA_AAAA, 32'hBBBB_BBBB, 32'hAAAA_AAAA, 32'hBBBB_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Forward Rs only", test_num);
            rsd = 32'h1111_1111;
            rtd = 32'h2222_2222;
            WrtBackData = 32'hFFFF_FFFF;
            extImm = 32'h3333_3333;
            shamt = 5'h00;
            fwRs = 1;
            fwRt = 0;
            sel_shamt = 0;
            sel_imm = 0;


            #1;



            check_outputs(32'hFFFF_FFFF, 32'h2222_2222, 32'hFFFF_FFFF, 32'h2222_2222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Forward Rt only", test_num);
            rsd = 32'h1111_1111;
            rtd = 32'h2222_2222;
            WrtBackData = 32'hFFFF_FFFF;
            extImm = 32'h3333_3333;
            shamt = 5'h00;
            fwRs = 0;
            fwRt = 1;
            sel_shamt = 0;
            sel_imm = 0;


            #1;



            check_outputs(32'h1111_1111, 32'hFFFF_FFFF, 32'h1111_1111, 32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Forward both Rs and Rt", test_num);
            rsd = 32'h1111_1111;
            rtd = 32'h2222_2222;
            WrtBackData = 32'h8888_8888;
            extImm = 32'h3333_3333;
            shamt = 5'h00;
            fwRs = 1;
            fwRt = 1;
            sel_shamt = 0;
            sel_imm = 0;


            #1;



            check_outputs(32'h8888_8888, 32'h8888_8888, 32'h8888_8888, 32'h8888_8888);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Select Shift Amount for busA", test_num);
            rsd = 32'h1111_1111;
            rtd = 32'h2222_2222;
            WrtBackData = 32'h0;
            extImm = 32'h0;
            shamt = 5'h0A;
            fwRs = 0;
            fwRt = 0;
            sel_shamt = 1;
            sel_imm = 0;


            #1;



            check_outputs(32'h1111_1111, 32'h2222_2222, 32'h0000_000A, 32'h2222_2222);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Select Immediate for busB", test_num);
            rsd = 32'h1111_1111;
            rtd = 32'h2222_2222;
            WrtBackData = 32'h0;
            extImm = 32'h5555_6666;
            shamt = 5'h00;
            fwRs = 0;
            fwRt = 0;
            sel_shamt = 0;
            sel_imm = 1;


            #1;



            check_outputs(32'h1111_1111, 32'h2222_2222, 32'h1111_1111, 32'h5555_6666);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Mixed - Forwarding and Selections active", test_num);
            rsd = 32'h1010_1010;
            rtd = 32'h2020_2020;
            WrtBackData = 32'h3030_3030;
            extImm = 32'h4040_4040;
            shamt = 5'h05;
            fwRs = 1;
            fwRt = 1;
            sel_shamt = 1;
            sel_imm = 1;






            #1;







            check_outputs(32'h3030_3030, 32'h3030_3030, 32'h0000_0005, 32'h4040_4040);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Sel_shamt=1 with Forwarding logic verification", test_num);
            rsd = 32'h0;
            rtd = 32'h1234_5678;
            WrtBackData = 32'hDEAD_BEEF;
            extImm = 32'h0;
            shamt = 5'h10;
            fwRs = 1;
            fwRt = 0;
            sel_shamt = 1;
            sel_imm = 0;






            #1;







            check_outputs(32'hDEAD_BEEF, 32'h1234_5678, 32'h0000_0010, 32'h1234_5678);
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
        input [31:0] expected_FwRsd;
        input [31:0] expected_FwRtd;
        input [31:0] expected_busA;
        input [31:0] expected_busB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_FwRsd === (expected_FwRsd ^ FwRsd ^ expected_FwRsd) &&
                expected_FwRtd === (expected_FwRtd ^ FwRtd ^ expected_FwRtd) &&
                expected_busA === (expected_busA ^ busA ^ expected_busA) &&
                expected_busB === (expected_busB ^ busB ^ expected_busB)) begin
                $display("PASS");
                $display("  Outputs: FwRsd=%h, FwRtd=%h, busA=%h, busB=%h",
                         FwRsd, FwRtd, busA, busB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: FwRsd=%h, FwRtd=%h, busA=%h, busB=%h",
                         expected_FwRsd, expected_FwRtd, expected_busA, expected_busB);
                $display("  Got:      FwRsd=%h, FwRtd=%h, busA=%h, busB=%h",
                         FwRsd, FwRtd, busA, busB);
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
