`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] flipin;
    wire [15:0] flipout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .flipin(flipin),
        .flipout(flipout)
    );
    task testcase001;

    begin
        test_num = 1;
        flipin = 16'h1234;
        #1;

        check_outputs(16'h3412);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        flipin = 16'hAABB;
        #1;

        check_outputs(16'hBBAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        flipin = 16'h00FF;
        #1;

        check_outputs(16'hFF00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        flipin = 16'hFF00;
        #1;

        check_outputs(16'h00FF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        flipin = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        flipin = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        flipin = 16'h55AA;
        #1;

        check_outputs(16'hAA55);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        flipin = 16'h0102;
        #1;

        check_outputs(16'h0201);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        flipin = 16'h8000;
        #1;

        check_outputs(16'h0080);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        flipin = 16'hC0DE;
        #1;

        check_outputs(16'hDEC0);
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
        input [15:0] expected_flipout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_flipout === (expected_flipout ^ flipout ^ expected_flipout)) begin
                $display("PASS");
                $display("  Outputs: flipout=%h",
                         flipout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flipout=%h",
                         expected_flipout);
                $display("  Got:      flipout=%h",
                         flipout);
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
