`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] SEL;
    reg [5:0] rstatus;
    wire [3:0] RAMSEL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SEL(SEL),
        .rstatus(rstatus),
        .RAMSEL(RAMSEL)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: SEL=000 (Case 0)", test_num);
        SEL = 3'b000;
        rstatus = 6'b000000;
        #10;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: SEL=001 (Case 1)", test_num);
        SEL = 3'b001;
        rstatus = 6'b000000;
        #10;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: SEL=010 (Case 2)", test_num);
        SEL = 3'b010;
        rstatus = 6'b000000;
        #10;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: SEL=011 (Case 3)", test_num);
        SEL = 3'b011;
        rstatus = 6'b000000;
        #10;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: SEL=100 (Case 4 - rstatus dependency 1)", test_num);
        SEL = 3'b100;
        rstatus = 6'b101010;
        #10;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: SEL=100 (Case 4 - rstatus dependency 2)", test_num);
        SEL = 3'b100;
        rstatus = 6'b010101;
        #10;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: SEL=101 (Case 5 - rstatus field select)", test_num);
        SEL = 3'b101;
        rstatus = 6'b110011;
        #10;

        #1;


        check_outputs(4'b1100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: SEL=110 (Default Case)", test_num);
        SEL = 3'b110;
        rstatus = 6'b111111;
        #10;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: SEL=111 (Default Case)", test_num);
        SEL = 3'b111;
        rstatus = 6'b111111;
        #10;
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_RAMSEL;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RAMSEL === (expected_RAMSEL ^ RAMSEL ^ expected_RAMSEL)) begin
                $display("PASS");
                $display("  Outputs: RAMSEL=%h",
                         RAMSEL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RAMSEL=%h",
                         expected_RAMSEL);
                $display("  Got:      RAMSEL=%h",
                         RAMSEL);
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
