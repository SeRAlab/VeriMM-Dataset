`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] B;
    reg [31:0] J;
    reg [31:0] Jr;
    reg [31:0] PCAdd4;
    reg [2:0] PCSrc;
    wire [31:0] nextAddr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .J(J),
        .Jr(Jr),
        .PCAdd4(PCAdd4),
        .PCSrc(PCSrc),
        .nextAddr(nextAddr)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: PCSrc=000, expected nextAddr = PCAdd4", test_num);
            PCAdd4 = 32'h0000_0004;
            B      = 32'h1111_1111;
            J      = 32'h2222_2222;
            Jr     = 32'h3333_3333;
            PCSrc  = 3'b000;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: PCSrc=001, expected nextAddr = B", test_num);
            PCAdd4 = 32'h0000_0004;
            B      = 32'hBEEF_CAFE;
            J      = 32'h2222_2222;
            Jr     = 32'h3333_3333;
            PCSrc  = 3'b001;
            #1;

            check_outputs(32'hBEEF_CAFE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: PCSrc=010, expected nextAddr = J", test_num);
            PCAdd4 = 32'h0000_0004;
            B      = 32'h1111_1111;
            J      = 32'hA5A5_5A5A;
            Jr     = 32'h3333_3333;
            PCSrc  = 3'b010;
            #1;

            check_outputs(32'hA5A5_5A5A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: PCSrc=011, expected nextAddr = J", test_num);
            PCAdd4 = 32'h0000_0004;
            B      = 32'h1111_1111;
            J      = 32'h5A5A_A5A5;
            Jr     = 32'h3333_3333;
            PCSrc  = 3'b011;
            #1;

            check_outputs(32'h5A5A_A5A5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: PCSrc=100, expected nextAddr = Jr", test_num);
            PCAdd4 = 32'h0000_0004;
            B      = 32'h1111_1111;
            J      = 32'h2222_2222;
            Jr     = 32'h8888_7777;
            PCSrc  = 3'b100;
            #1;

            check_outputs(32'h8888_7777);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: PCSrc=101, expected nextAddr = Jr", test_num);
            PCAdd4 = 32'h0000_0004;
            B      = 32'h1111_1111;
            J      = 32'h2222_2222;
            Jr     = 32'h1234_5678;
            PCSrc  = 3'b101;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Switching data while PCSrc stays 000 (PCAdd4 selection)", test_num);
            PCSrc  = 3'b000;
            B      = 32'hFFFF_FFFF;
            J      = 32'hFFFF_FFFF;
            Jr     = 32'hFFFF_FFFF;
            PCAdd4 = 32'hAAAA_BBBB;
            #1;

            check_outputs(32'hAAAA_BBBB);
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
        input [31:0] expected_nextAddr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nextAddr === (expected_nextAddr ^ nextAddr ^ expected_nextAddr)) begin
                $display("PASS");
                $display("  Outputs: nextAddr=%h",
                         nextAddr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nextAddr=%h",
                         expected_nextAddr);
                $display("  Got:      nextAddr=%h",
                         nextAddr);
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
