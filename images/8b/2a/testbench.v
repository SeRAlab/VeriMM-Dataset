`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Input 0x00 (Upper 4 bits: 0)", test_num);
        in = 8'h00;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input 0x1F (Upper 4 bits: 1, Lower bits ignored)", test_num);
        in = 8'h1F;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Input 0x2A (Upper 4 bits: 2, Lower bits ignored)", test_num);
        in = 8'h2A;
        #1;

        check_outputs(16'h0004);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Input 0x30 (Upper 4 bits: 3)", test_num);
        in = 8'h30;
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Input 0x45 (Upper 4 bits: 4)", test_num);
        in = 8'h45;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Input 0x5E (Upper 4 bits: 5)", test_num);
        in = 8'h5E;
        #1;

        check_outputs(16'h0020);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Input 0x61 (Upper 4 bits: 6)", test_num);
        in = 8'h61;
        #1;

        check_outputs(16'h0040);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Input 0x72 (Upper 4 bits: 7)", test_num);
        in = 8'h72;
        #1;

        check_outputs(16'h0080);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Input 0x89 (Upper 4 bits: 8)", test_num);
        in = 8'h89;
        #1;

        check_outputs(16'h0100);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Input 0x90 (Upper 4 bits: 9)", test_num);
        in = 8'h90;
        #1;

        check_outputs(16'h0200);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case %0d: Input 0xAB (Upper 4 bits: 10)", test_num);
        in = 8'hAB;
        #1;

        check_outputs(16'h0400);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test Case %0d: Input 0xB3 (Upper 4 bits: 11)", test_num);
        in = 8'hB3;
        #1;

        check_outputs(16'h0800);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test Case %0d: Input 0xC4 (Upper 4 bits: 12)", test_num);
        in = 8'hC4;
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Test Case %0d: Input 0xD6 (Upper 4 bits: 13)", test_num);
        in = 8'hD6;
        #1;

        check_outputs(16'h2000);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Test Case %0d: Input 0xE7 (Upper 4 bits: 14)", test_num);
        in = 8'hE7;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Test Case %0d: Input 0xFF (Upper 4 bits: 15)", test_num);
        in = 8'hFF;
        #1;

        check_outputs(16'h8000);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
