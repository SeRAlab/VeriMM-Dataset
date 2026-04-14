`timescale 1ns/1ps

module SEG7_LUT_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] iDIG;
    wire [6:0] oSEG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SEG7_LUT dut (
        .iDIG(iDIG),
        .oSEG(oSEG)
    );
    task testcase001;

        begin
            test_num = 1;
            iDIG = 4'h0;
            $display("Test Case 001: iDIG = 4'h0");
            #1;

            check_outputs(7'h40);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            iDIG = 4'h1;
            $display("Test Case 002: iDIG = 4'h1");
            #1;

            check_outputs(7'h79);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            iDIG = 4'h2;
            $display("Test Case 003: iDIG = 4'h2");
            #1;

            check_outputs(7'h24);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            iDIG = 4'h3;
            $display("Test Case 004: iDIG = 4'h3");
            #1;

            check_outputs(7'h30);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            iDIG = 4'h4;
            $display("Test Case 005: iDIG = 4'h4");
            #1;

            check_outputs(7'h19);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            iDIG = 4'h5;
            $display("Test Case 006: iDIG = 4'h5");
            #1;

            check_outputs(7'h12);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            iDIG = 4'h6;
            $display("Test Case 007: iDIG = 4'h6");
            #1;

            check_outputs(7'h02);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            iDIG = 4'h7;
            $display("Test Case 008: iDIG = 4'h7");
            #1;

            check_outputs(7'h78);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            iDIG = 4'h8;
            $display("Test Case 009: iDIG = 4'h8");
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            iDIG = 4'h9;
            $display("Test Case 010: iDIG = 4'h9");
            #1;

            check_outputs(7'h10);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            iDIG = 4'hA;
            $display("Test Case 011: iDIG = 4'hA");
            #1;

            check_outputs(7'h08);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            iDIG = 4'hB;
            $display("Test Case 012: iDIG = 4'hB");
            #1;

            check_outputs(7'h03);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            iDIG = 4'hC;
            $display("Test Case 013: iDIG = 4'hC");
            #1;

            check_outputs(7'h46);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            iDIG = 4'hD;
            $display("Test Case 014: iDIG = 4'hD");
            #1;

            check_outputs(7'h21);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            iDIG = 4'hE;
            $display("Test Case 015: iDIG = 4'hE");
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            iDIG = 4'hF;
            $display("Test Case 016: iDIG = 4'hF");
            #1;

            check_outputs(7'h0E);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SEG7_LUT Testbench");
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [6:0] expected_oSEG;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oSEG === (expected_oSEG ^ oSEG ^ expected_oSEG)) begin
                $display("PASS");
                $display("  Outputs: oSEG=%h",
                         oSEG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oSEG=%h",
                         expected_oSEG);
                $display("  Got:      oSEG=%h",
                         oSEG);
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
