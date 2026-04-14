`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_rs1;
    reg [31:0] data_rs2;
    reg [2:0] funct3;
    wire jmpb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_rs1(data_rs1),
        .data_rs2(data_rs2),
        .funct3(funct3),
        .jmpb(jmpb)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: BEQ - Equal", test_num);
            funct3 = 3'b000;
            data_rs1 = 32'd100;
            data_rs2 = 32'd100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: BEQ - Not Equal", test_num);
            funct3 = 3'b000;
            data_rs1 = 32'd100;
            data_rs2 = 32'd200;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: BNE - Equal", test_num);
            funct3 = 3'b001;
            data_rs1 = 32'hAAAA_BBBB;
            data_rs2 = 32'hAAAA_BBBB;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: BNE - Not Equal", test_num);
            funct3 = 3'b001;
            data_rs1 = 32'hAAAA_BBBB;
            data_rs2 = 32'hAAAA_CCCC;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: BLT (Signed) - Negative < Positive", test_num);
            funct3 = 3'b100;
            data_rs1 = 32'hFFFF_FFFF;
            data_rs2 = 32'h0000_0001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: BLT (Signed) - Positive < Negative", test_num);
            funct3 = 3'b100;
            data_rs1 = 32'h0000_0001;
            data_rs2 = 32'hFFFF_FFFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: BGE (Signed) - Equal", test_num);
            funct3 = 3'b101;
            data_rs1 = 32'h8000_0000;
            data_rs2 = 32'h8000_0000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: BGE (Signed) - Greater", test_num);
            funct3 = 3'b101;
            data_rs1 = 32'd50;
            data_rs2 = -32'd50;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: BLTU (Unsigned) - Max vs Min", test_num);
            funct3 = 3'b110;
            data_rs1 = 32'hFFFF_FFFF;
            data_rs2 = 32'h0000_0001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: BGEU (Unsigned) - Max vs Min", test_num);
            funct3 = 3'b111;
            data_rs1 = 32'hFFFF_FFFF;
            data_rs2 = 32'h0000_0001;
            #1;

            check_outputs(1'b1);
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
        input expected_jmpb;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_jmpb === (expected_jmpb ^ jmpb ^ expected_jmpb)) begin
                $display("PASS");
                $display("  Outputs: jmpb=%b",
                         jmpb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: jmpb=%b",
                         expected_jmpb);
                $display("  Got:      jmpb=%b",
                         jmpb);
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
