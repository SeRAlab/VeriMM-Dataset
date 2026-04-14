`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] B;
    wire [7:0] G;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .G(G)
    );
    task testcase001;

        begin
            test_num = 1;
            B = 8'h00;
            $display("Test %0d: Binary Input 0x00", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            B = 8'h01;
            $display("Test %0d: Binary Input 0x01", test_num);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            B = 8'h02;
            $display("Test %0d: Binary Input 0x02", test_num);
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            B = 8'h03;
            $display("Test %0d: Binary Input 0x03", test_num);
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            B = 8'h07;
            $display("Test %0d: Binary Input 0x07", test_num);
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            B = 8'h08;
            $display("Test %0d: Binary Input 0x08", test_num);
            #1;

            check_outputs(8'h0C);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            B = 8'h55;
            $display("Test %0d: Binary Input 0x55", test_num);
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            B = 8'hAA;
            $display("Test %0d: Binary Input 0xAA", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            B = 8'h80;
            $display("Test %0d: Binary Input 0x80", test_num);
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            B = 8'hFF;
            $display("Test %0d: Binary Input 0xFF", test_num);
            #1;

            check_outputs(8'h80);
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
        input [7:0] expected_G;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G === (expected_G ^ G ^ expected_G)) begin
                $display("PASS");
                $display("  Outputs: G=%h",
                         G);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G=%h",
                         expected_G);
                $display("  Got:      G=%h",
                         G);
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
