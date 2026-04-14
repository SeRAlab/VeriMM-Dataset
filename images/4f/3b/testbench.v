`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] iData;
    reg [2:0] sel;
    wire [31:0] oData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iData(iData),
        .sel(sel),
        .oData(oData)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pass-through (sel=0)", test_num);
        iData = 32'hA5A5_5A5A;
        sel = 3'b000;
        #10;
        #1;

        check_outputs(32'hA5A5_5A5A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero-extend lower 16 bits (sel=1)", test_num);
        iData = 32'hDEAD_BEEF;
        sel = 3'b001;
        #10;
        #1;

        check_outputs(32'h0000_BEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sign-extend lower 16 bits - Negative case (sel=2)", test_num);

        iData = 32'h1234_8005;
        sel = 3'b010;
        #10;
        #1;

        check_outputs(32'hFFFF_8005);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sign-extend lower 16 bits - Positive case (sel=2)", test_num);

        iData = 32'h1234_7FFF;
        sel = 3'b010;
        #10;
        #1;

        check_outputs(32'h0000_7FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift left preserving sign bit - Negative (sel=3)", test_num);


        iData = 32'h8000_0001;
        sel = 3'b011;
        #10;
        #1;

        check_outputs(32'h8000_0002);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Shift left preserving sign bit - Positive (sel=3)", test_num);



        iData = 32'h4000_0001;
        sel = 3'b011;
        #10;
        #1;

        check_outputs(32'h0000_0002);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: High-Impedance check (sel=4)", test_num);
        iData = 32'hFFFF_FFFF;
        sel = 3'b100;
        #10;


        #1;



        check_outputs(32'hzzzz_zzzz);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: High-Impedance check (sel=7)", test_num);
        iData = 32'h1234_5678;
        sel = 3'b111;
        #10;
        #1;

        check_outputs(32'hzzzz_zzzz);
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
        input [31:0] expected_oData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oData === (expected_oData ^ oData ^ expected_oData)) begin
                $display("PASS");
                $display("  Outputs: oData=%h",
                         oData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oData=%h",
                         expected_oData);
                $display("  Got:      oData=%h",
                         oData);
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
