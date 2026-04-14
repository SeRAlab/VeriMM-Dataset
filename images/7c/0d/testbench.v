`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [15:0] registradorin;
    wire [15:0] registradorout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .registradorin(registradorin),
        .registradorout(registradorout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input 0x0000 (0)", test_num);
            registradorin = 16'h0000;
            @(posedge clk);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input 0x0005 (5)", test_num);
            registradorin = 16'h0005;
            @(posedge clk);
            #1;

            check_outputs(16'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input 0x0010 (10)", test_num);
            registradorin = 16'h0010;
            @(posedge clk);
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input 0x0100 (100)", test_num);
            registradorin = 16'h0100;
            @(posedge clk);
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input 0x1000 (1000)", test_num);
            registradorin = 16'h1000;
            @(posedge clk);
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input 0x1234 (1234)", test_num);
            registradorin = 16'h1234;
            @(posedge clk);
            #1;

            check_outputs(16'd1234);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input 0x9999 (9999)", test_num);
            registradorin = 16'h9999;
            @(posedge clk);
            #1;

            check_outputs(16'd9999);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input 0xFFFF (Boundary Check)", test_num);
            registradorin = 16'hFFFF;
            @(posedge clk);
            #1;

            check_outputs(16'd16665);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input 0x0A0B (Hex values in segments)", test_num);
            registradorin = 16'h0A0B;
            @(posedge clk);
            #1;

            check_outputs(16'd1011);
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
        input [15:0] expected_registradorout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_registradorout === (expected_registradorout ^ registradorout ^ expected_registradorout)) begin
                $display("PASS");
                $display("  Outputs: registradorout=%h",
                         registradorout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: registradorout=%h",
                         expected_registradorout);
                $display("  Got:      registradorout=%h",
                         registradorout);
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
