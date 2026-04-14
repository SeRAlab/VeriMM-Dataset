`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] iMultiplicador;
    reg [7:0] iMultiplicando;
    wire [7:0] oResult;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iMultiplicador(iMultiplicador),
        .iMultiplicando(iMultiplicando),
        .oResult(oResult)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        iMultiplicador = 4'd0;
        iMultiplicando = 8'd255;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        iMultiplicador = 4'd1;
        iMultiplicando = 8'd123;
        #1;

        check_outputs(8'd123);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        iMultiplicador = 4'd5;
        iMultiplicando = 8'd10;
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        iMultiplicador = 4'd3;
        iMultiplicando = 8'd85;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        iMultiplicador = 4'd4;
        iMultiplicando = 8'd64;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        iMultiplicador = 4'd12;
        iMultiplicando = 8'd7;
        #1;

        check_outputs(8'd84);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        iMultiplicador = 4'd15;
        iMultiplicando = 8'd2;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        iMultiplicador = 4'd15;
        iMultiplicando = 8'd255;
        #1;

        check_outputs(8'hF1);
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
        input [7:0] expected_oResult;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oResult === (expected_oResult ^ oResult ^ expected_oResult)) begin
                $display("PASS");
                $display("  Outputs: oResult=%h",
                         oResult);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oResult=%h",
                         expected_oResult);
                $display("  Got:      oResult=%h",
                         oResult);
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
