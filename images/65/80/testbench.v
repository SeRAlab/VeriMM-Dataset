`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] ALUOut;
    reg [2:0] CC;
    reg FU;
    reg [3:0] Op;
    wire Perform;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOut(ALUOut),
        .CC(CC),
        .FU(FU),
        .Op(Op),
        .Perform(Perform)
    );
    task testcase001;

        begin
            ALUOut = 16'h0000;
            CC = 3'b010;
            Op = 4'b0000;
            FU = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            ALUOut = 16'h0001;
            CC = 3'b001;
            Op = 4'b0000;
            FU = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            ALUOut = 16'h8000;
            CC = 3'b100;
            Op = 4'b0000;
            FU = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            ALUOut = 16'h0005;
            CC = 3'b010;
            Op = 4'b0000;
            FU = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            ALUOut = 16'h0000;
            CC = 3'b100;
            Op = 4'b0000;
            FU = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            ALUOut = 16'hFFFF;
            CC = 3'b110;
            Op = 4'b0000;
            FU = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            ALUOut = 16'h0000;
            CC = 3'b101;
            Op = 4'b0000;
            FU = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            ALUOut = 16'h1234;
            CC = 3'b111;
            Op = 4'b0000;
            FU = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            ALUOut = 16'hF000;
            CC = 3'b000;
            Op = 4'b0000;
            FU = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            ALUOut = 16'h7FFF;
            CC = 3'b001;
            Op = 4'b0000;
            FU = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            ALUOut = 16'h8001;
            CC = 3'b100;
            Op = 4'b0000;
            FU = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase012;

        begin
            ALUOut = 16'h0000;
            CC = 3'b010;
            Op = 4'b1111;
            FU = 1'b1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase013;

        begin
            ALUOut = 16'h0001;
            CC = 3'b001;
            Op = 4'b0000;
            FU = 1'b0;
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
        testcase013();
        
        
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
        input expected_Perform;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Perform === (expected_Perform ^ Perform ^ expected_Perform)) begin
                $display("PASS");
                $display("  Outputs: Perform=%b",
                         Perform);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Perform=%b",
                         expected_Perform);
                $display("  Got:      Perform=%b",
                         Perform);
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
