`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in1;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        in1 = 4'h0;
        #1;

        check_outputs(8'hC0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in1 = 4'h1;
        #1;

        check_outputs(8'hF9);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in1 = 4'h2;
        #1;

        check_outputs(8'hA4);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in1 = 4'h3;
        #1;

        check_outputs(8'hB0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in1 = 4'h4;
        #1;

        check_outputs(8'h99);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in1 = 4'h5;
        #1;

        check_outputs(8'h92);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in1 = 4'h6;
        #1;

        check_outputs(8'h82);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in1 = 4'h7;
        #1;

        check_outputs(8'hF8);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in1 = 4'h8;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in1 = 4'h9;
        #1;

        check_outputs(8'h90);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        in1 = 4'hA;
        #1;

        check_outputs(8'h88);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        in1 = 4'hB;
        #1;

        check_outputs(8'h83);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        in1 = 4'hC;
        #1;

        check_outputs(8'hC6);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        in1 = 4'hD;
        #1;

        check_outputs(8'hA1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        in1 = 4'hE;
        #1;

        check_outputs(8'h86);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        in1 = 4'hF;
        #1;

        check_outputs(8'h8E);
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
        input [7:0] expected_out;
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
