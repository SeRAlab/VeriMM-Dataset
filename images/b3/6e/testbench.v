`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] DatabusA;
    reg [31:0] DatabusB;
    reg [5:0] OpCode;
    wire branch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DatabusA(DatabusA),
        .DatabusB(DatabusB),
        .OpCode(OpCode),
        .branch(branch)
    );
    task testcase001;

    begin
        test_num = 1;
        OpCode = 6'h04;
        DatabusA = 32'd100;
        DatabusB = 32'd100;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        OpCode = 6'h04;
        DatabusA = 32'd100;
        DatabusB = 32'd200;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        OpCode = 6'h05;
        DatabusA = 32'd100;
        DatabusB = 32'd200;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        OpCode = 6'h05;
        DatabusA = 32'd100;
        DatabusB = 32'd100;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        OpCode = 6'h06;
        DatabusA = 32'hFFFF_FFFE;
        DatabusB = 32'h0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        OpCode = 6'h06;
        DatabusA = 32'h0;
        DatabusB = 32'h0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        OpCode = 6'h06;
        DatabusA = 32'h0000_0005;
        DatabusB = 32'h0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        OpCode = 6'h07;
        DatabusA = 32'h0000_000A;
        DatabusB = 32'h0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        OpCode = 6'h07;
        DatabusA = 32'h8000_0000;
        DatabusB = 32'h0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        OpCode = 6'h01;
        DatabusA = 32'hFFFF_FFFF;
        DatabusB = 32'h0000_0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        OpCode = 6'h01;
        DatabusA = 32'h0000_0000;
        DatabusB = 32'h0000_0001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        OpCode = 6'h00;
        DatabusA = 32'd50;
        DatabusB = 32'd50;
        #1;

        check_outputs(1'b0);
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
        input expected_branch;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_branch === (expected_branch ^ branch ^ expected_branch)) begin
                $display("PASS");
                $display("  Outputs: branch=%b",
                         branch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: branch=%b",
                         expected_branch);
                $display("  Got:      branch=%b",
                         branch);
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
