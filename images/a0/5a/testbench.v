`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] iA;
    reg [31:0] iB;
    reg [31:0] iC;
    reg [31:0] iD;
    reg [2:0] iEsc;
    wire [31:0] oSaida;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iA(iA),
        .iB(iB),
        .iC(iC),
        .iD(iD),
        .iEsc(iEsc),
        .oSaida(oSaida)
    );
    task testcase001;

    begin
        test_num = 1;
        iA = 32'h11111111;
        iB = 32'h22222222;
        iC = 32'h33333333;
        iD = 32'h44444444;
        iEsc = 3'b000;
        $display("Test %0d: Select iA (iEsc=0)", test_num);
        #1;

        check_outputs(32'h11111111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        iA = 32'h11111111;
        iB = 32'h22222222;
        iC = 32'h33333333;
        iD = 32'h44444444;
        iEsc = 3'b001;
        $display("Test %0d: Select iB (iEsc=1)", test_num);
        #1;

        check_outputs(32'h22222222);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        iA = 32'h11111111;
        iB = 32'h22222222;
        iC = 32'h33333333;
        iD = 32'h44444444;
        iEsc = 3'b010;
        $display("Test %0d: Select iC (iEsc=2)", test_num);
        #1;

        check_outputs(32'h33333333);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        iA = 32'h11111111;
        iB = 32'h22222222;
        iC = 32'h33333333;
        iD = 32'h44444444;
        iEsc = 3'b011;
        $display("Test %0d: Select iD (iEsc=3)", test_num);
        #1;

        check_outputs(32'h44444444);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        iA = 32'hFFFFFFFF;
        iB = 32'h00000000;
        iC = 32'h55555555;
        iD = 32'hAAAAAAAA;
        iEsc = 3'b100;
        $display("Test %0d: Invalid Select (iEsc=4)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        iA = 32'hDEADC0DE;
        iB = 32'hBEEFCAFE;
        iC = 32'h12345678;
        iD = 32'h87654321;
        iEsc = 3'b111;
        $display("Test %0d: Invalid Select (iEsc=7)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        iA = 32'h0F0F0F0F;
        iB = 32'hF0F0F0F0;
        iC = 32'h5A5A5A5A;
        iD = 32'hA5A5A5A5;
        iEsc = 3'b000;
        $display("Test %0d: Verify data change on iA", test_num);
        #1;

        check_outputs(32'h0F0F0F0F);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        iA = 32'h0F0F0F0F;
        iB = 32'hF0F0F0F0;
        iC = 32'h5A5A5A5A;
        iD = 32'hA5A5A5A5;
        iEsc = 3'b010;
        $display("Test %0d: Verify data change on iC", test_num);
        #1;

        check_outputs(32'h5A5A5A5A);
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
        input [31:0] expected_oSaida;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oSaida === (expected_oSaida ^ oSaida ^ expected_oSaida)) begin
                $display("PASS");
                $display("  Outputs: oSaida=%h",
                         oSaida);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oSaida=%h",
                         expected_oSaida);
                $display("  Got:      oSaida=%h",
                         oSaida);
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
