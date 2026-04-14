`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] M0;
    reg [15:0] M1;
    reg [15:0] M10;
    reg [15:0] M11;
    reg [15:0] M12;
    reg [15:0] M13;
    reg [15:0] M14;
    reg [15:0] M15;
    reg [15:0] M2;
    reg [15:0] M3;
    reg [15:0] M4;
    reg [15:0] M5;
    reg [15:0] M6;
    reg [15:0] M7;
    reg [15:0] M8;
    reg [15:0] M9;
    reg [3:0] sel;
    wire [15:0] OU;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M0(M0),
        .M1(M1),
        .M10(M10),
        .M11(M11),
        .M12(M12),
        .M13(M13),
        .M14(M14),
        .M15(M15),
        .M2(M2),
        .M3(M3),
        .M4(M4),
        .M5(M5),
        .M6(M6),
        .M7(M7),
        .M8(M8),
        .M9(M9),
        .sel(sel),
        .OU(OU)
    );
    task testcase001;

        begin
            test_num = 1;

            M0 = 16'h0000; M1 = 16'h1111; M2 = 16'h2222; M3 = 16'h3333;
            M4 = 16'h4444; M5 = 16'h5555; M6 = 16'h6666; M7 = 16'h7777;
            M8 = 16'h8888; M9 = 16'h9999; M10 = 16'hAAAA; M11 = 16'hBBBB;
            M12 = 16'hCCCC; M13 = 16'hDDDD; M14 = 16'hEEEE; M15 = 16'hFFFF;

            sel = 4'd0;
            $display("Testcase %0d: Selecting M0", test_num);
            #1;

            check_outputs(M0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            sel = 4'd15;
            $display("Testcase %0d: Selecting M15", test_num);
            #1;

            check_outputs(M15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            sel = 4'd7;
            $display("Testcase %0d: Selecting M7", test_num);
            #1;

            check_outputs(M7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            sel = 4'd10;
            $display("Testcase %0d: Selecting M10", test_num);
            #1;

            check_outputs(M10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            sel = 4'd4;
            M4 = 16'hABCD;
            $display("Testcase %0d: Changing M4 and checking output", test_num);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            M0 = 16'h0000; M1 = 16'h0000; M2 = 16'h0000; M3 = 16'h0000;
            M4 = 16'h0000; M5 = 16'h0000; M6 = 16'h0000; M7 = 16'h0000;
            M8 = 16'h5A5A;
            M9 = 16'h0000; M10 = 16'h0000; M11 = 16'h0000;
            M12 = 16'h0000; M13 = 16'h0000; M14 = 16'h0000; M15 = 16'h0000;

            sel = 4'd8;
            $display("Testcase %0d: Select unique M8 among zeros", test_num);
            #1;

            check_outputs(16'h5A5A);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            sel = 4'd1;
            $display("Testcase %0d: Verifying M1 selection after data change", test_num);
            #1;

            check_outputs(M1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;

            M12 = 16'hFFFF;
            sel = 4'd12;
            $display("Testcase %0d: Selecting M12 (all ones)", test_num);
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_OU;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OU === (expected_OU ^ OU ^ expected_OU)) begin
                $display("PASS");
                $display("  Outputs: OU=%h",
                         OU);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OU=%h",
                         expected_OU);
                $display("  Got:      OU=%h",
                         OU);
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
