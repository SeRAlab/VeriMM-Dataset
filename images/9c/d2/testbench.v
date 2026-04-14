`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg iorq;
    reg mreq;
    reg rd;
    reg wr;
    wire en254r;
    wire en254w;
    wire ramce;
    wire romce;
    wire vramdec;
    wire xramce;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .iorq(iorq),
        .mreq(mreq),
        .rd(rd),
        .wr(wr),
        .en254r(en254r),
        .en254w(en254w),
        .ramce(ramce),
        .romce(romce),
        .vramdec(vramdec),
        .xramce(xramce)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %03d: ROM Access (0x1234)", test_num);
            a = 16'h1234; mreq = 1; iorq = 0; rd = 1; wr = 0;


            #1;



            check_outputs(0, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %03d: VRAM Access (0x5A5A)", test_num);
            a = 16'h5A5A; mreq = 1; iorq = 0; rd = 1; wr = 0;

            #1;


            check_outputs(0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %03d: RAM Access (0x9000)", test_num);
            a = 16'h9000; mreq = 1; iorq = 0; rd = 1; wr = 0;

            #1;


            check_outputs(0, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %03d: XRAM Access (0xE000)", test_num);
            a = 16'hE000; mreq = 1; iorq = 0; rd = 1; wr = 0;

            #1;


            check_outputs(0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %03d: Port 254 Read", test_num);
            a = 16'h00FE; mreq = 0; iorq = 1; rd = 1; wr = 0;

            #1;


            check_outputs(1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %03d: Port 254 Write", test_num);
            a = 16'h00FE; mreq = 0; iorq = 1; rd = 0; wr = 1;

            #1;


            check_outputs(0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %03d: Idle (No MREQ/IORQ)", test_num);
            a = 16'h0000; mreq = 0; iorq = 0; rd = 0; wr = 0;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %03d: Odd Port Read (Not 254)", test_num);
            a = 16'h00FF; mreq = 0; iorq = 1; rd = 1; wr = 0;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0);
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
        input expected_en254r;
        input expected_en254w;
        input expected_ramce;
        input expected_romce;
        input expected_vramdec;
        input expected_xramce;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_en254r === (expected_en254r ^ en254r ^ expected_en254r) &&
                expected_en254w === (expected_en254w ^ en254w ^ expected_en254w) &&
                expected_ramce === (expected_ramce ^ ramce ^ expected_ramce) &&
                expected_romce === (expected_romce ^ romce ^ expected_romce) &&
                expected_vramdec === (expected_vramdec ^ vramdec ^ expected_vramdec) &&
                expected_xramce === (expected_xramce ^ xramce ^ expected_xramce)) begin
                $display("PASS");
                $display("  Outputs: en254r=%b, en254w=%b, ramce=%b, romce=%b, vramdec=%b, xramce=%b",
                         en254r, en254w, ramce, romce, vramdec, xramce);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: en254r=%b, en254w=%b, ramce=%b, romce=%b, vramdec=%b, xramce=%b",
                         expected_en254r, expected_en254w, expected_ramce, expected_romce, expected_vramdec, expected_xramce);
                $display("  Got:      en254r=%b, en254w=%b, ramce=%b, romce=%b, vramdec=%b, xramce=%b",
                         en254r, en254w, ramce, romce, vramdec, xramce);
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
