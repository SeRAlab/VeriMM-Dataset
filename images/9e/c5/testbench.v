`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] number;
    wire [7:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .number(number),
        .data(data)
    );
    task testcase001;

    begin
        test_num = 1;
        number = 4'h0;
        $display("Test Case 001: Input 0x0");
        #1;

        check_outputs(8'h3F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        number = 4'h1;
        $display("Test Case 002: Input 0x1");
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        number = 4'h2;
        $display("Test Case 003: Input 0x2");
        #1;

        check_outputs(8'h5B);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        number = 4'h3;
        $display("Test Case 004: Input 0x3");
        #1;

        check_outputs(8'h4F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        number = 4'h4;
        $display("Test Case 005: Input 0x4");
        #1;

        check_outputs(8'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        number = 4'h5;
        $display("Test Case 006: Input 0x5");
        #1;

        check_outputs(8'h6D);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        number = 4'h6;
        $display("Test Case 007: Input 0x6");
        #1;

        check_outputs(8'h7D);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        number = 4'h7;
        $display("Test Case 008: Input 0x7");
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        number = 4'h8;
        $display("Test Case 009: Input 0x8");
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        number = 4'h9;
        $display("Test Case 010: Input 0x9");
        #1;

        check_outputs(8'h6F);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        number = 4'hA;
        $display("Test Case 011: Input 0xA");
        #1;

        check_outputs(8'h77);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        number = 4'hB;
        $display("Test Case 012: Input 0xB");
        #1;

        check_outputs(8'h7C);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        number = 4'hC;
        $display("Test Case 013: Input 0xC");
        #1;

        check_outputs(8'h39);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        number = 4'hD;
        $display("Test Case 014: Input 0xD");
        #1;

        check_outputs(8'h5E);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        number = 4'hE;
        $display("Test Case 015: Input 0xE");
        #1;

        check_outputs(8'h79);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        number = 4'hF;
        $display("Test Case 016: Input 0xF");
        #1;

        check_outputs(8'h71);
    end
        endtask

    task testcase017;

    begin
        test_num = 17;
        number = 4'bxxxx;
        $display("Test Case 017: Input 4'bxxxx (Default Case)");
        #1;

        check_outputs(8'h00);
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        testcase017();
        
        
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
        input [7:0] expected_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
