`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUop;
    reg clk;
    reg [5:0] instru;
    wire [2:0] contALU;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUop(ALUop),
        .clk(clk),
        .instru(instru),
        .contALU(contALU)
    );
    task testcase001;

        begin
            test_num = 1;
            ALUop = 2'b00;
            instru = 6'b000000;
            @(posedge clk);
            #1;
            $display("Test %0d: ALUop=00 (Directly ADD)", test_num);
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            ALUop = 2'b01;
            instru = 6'b000000;
            @(posedge clk);
            #1;
            $display("Test %0d: ALUop=01 (Directly SUB)", test_num);
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            ALUop = 2'b10;
            instru = 6'b100000;
            @(posedge clk);
            #1;
            $display("Test %0d: ALUop=10, instru=ADD", test_num);
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            ALUop = 2'b10;
            instru = 6'b100010;
            @(posedge clk);
            #1;
            $display("Test %0d: ALUop=10, instru=SUB", test_num);
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            ALUop = 2'b10;
            instru = 6'b100100;
            @(posedge clk);
            #1;
            $display("Test %0d: ALUop=10, instru=AND", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            ALUop = 2'b10;
            instru = 6'b100101;
            @(posedge clk);
            #1;
            $display("Test %0d: ALUop=10, instru=OR", test_num);
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            ALUop = 2'b10;
            instru = 6'b101010;
            @(posedge clk);
            #1;
            $display("Test %0d: ALUop=10, instru=SLT", test_num);
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            ALUop = 2'b10;
            instru = 6'b100111;
            @(posedge clk);
            #1;
            $display("Test %0d: ALUop=10, instru=NOR", test_num);
            #1;

            check_outputs(3'b100);
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
        input [2:0] expected_contALU;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_contALU === (expected_contALU ^ contALU ^ expected_contALU)) begin
                $display("PASS");
                $display("  Outputs: contALU=%h",
                         contALU);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: contALU=%h",
                         expected_contALU);
                $display("  Got:      contALU=%h",
                         contALU);
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
