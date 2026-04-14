`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] X;
    wire [6:0] SSD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .X(X),
        .SSD(SSD)
    );
    task testcase001;

    begin
        $display("Test Case 001: Input X = 0");
        X = 4'h0;
        #1;

        check_outputs(7'h3F);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Input X = 1");
        X = 4'h1;
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Input X = 2");
        X = 4'h2;
        #1;

        check_outputs(7'h5B);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Input X = 3");
        X = 4'h3;
        #1;

        check_outputs(7'h4F);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Input X = 4");
        X = 4'h4;
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Input X = 5");
        X = 4'h5;
        #1;

        check_outputs(7'h6D);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Input X = 6");
        X = 4'h6;
        #1;

        check_outputs(7'h7D);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Input X = 7");
        X = 4'h7;
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: Input X = 8");
        X = 4'h8;
        #1;

        check_outputs(7'h7F);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: Input X = 9");
        X = 4'h9;
        #1;

        check_outputs(7'h6F);
    end
        endtask

    task testcase011;

    begin
        $display("Test Case 011: Input X = A");
        X = 4'hA;
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase012;

    begin
        $display("Test Case 012: Input X = B");
        X = 4'hB;
        #1;

        check_outputs(7'h7C);
    end
        endtask

    task testcase013;

    begin
        $display("Test Case 013: Input X = C");
        X = 4'hC;
        #1;

        check_outputs(7'h39);
    end
        endtask

    task testcase014;

    begin
        $display("Test Case 014: Input X = D");
        X = 4'hD;
        #1;

        check_outputs(7'h5E);
    end
        endtask

    task testcase015;

    begin
        $display("Test Case 015: Input X = E");
        X = 4'hE;
        #1;

        check_outputs(7'h79);
    end
        endtask

    task testcase016;

    begin
        $display("Test Case 016: Input X = F");
        X = 4'hF;
        #1;

        check_outputs(7'h71);
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
        input [6:0] expected_SSD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SSD === (expected_SSD ^ SSD ^ expected_SSD)) begin
                $display("PASS");
                $display("  Outputs: SSD=%h",
                         SSD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SSD=%h",
                         expected_SSD);
                $display("  Got:      SSD=%h",
                         SSD);
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
