`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALUout_M;
    reg [31:0] Data1;
    reg [31:0] Data2;
    reg [2:0] ForwardRSD;
    reg [2:0] ForwardRTD;
    reg [31:0] MDout_M;
    reg [31:0] PC8_E;
    reg [31:0] PC8_M;
    reg [31:0] result_W;
    reg [31:0] result_WD;
    wire [31:0] D1;
    wire [31:0] D2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUout_M(ALUout_M),
        .Data1(Data1),
        .Data2(Data2),
        .ForwardRSD(ForwardRSD),
        .ForwardRTD(ForwardRTD),
        .MDout_M(MDout_M),
        .PC8_E(PC8_E),
        .PC8_M(PC8_M),
        .result_W(result_W),
        .result_WD(result_WD),
        .D1(D1),
        .D2(D2)
    );
    task init_inputs;

        begin
            Data1     = 32'h1111_1111;
            Data2     = 32'h2222_2222;
            ALUout_M  = 32'hAAAA_AAAA;
            MDout_M   = 32'hBBBB_BBBB;
            PC8_M     = 32'hCCCC_CCCC;
            result_W  = 32'hDDDD_DDDD;
            PC8_E     = 32'hEEEE_EEEE;
            result_WD = 32'hFFFF_FFFF;
            ForwardRSD = 3'b000;
            ForwardRTD = 3'b000;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            init_inputs();
            ForwardRSD = 3'd0;
            ForwardRTD = 3'd0;
            #1;

            check_outputs(32'h1111_1111, 32'h2222_2222);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            init_inputs();
            ForwardRSD = 3'd1;
            ForwardRTD = 3'd1;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'hAAAA_AAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            init_inputs();
            ForwardRSD = 3'd2;
            ForwardRTD = 3'd2;
            #1;

            check_outputs(32'hBBBB_BBBB, 32'hBBBB_BBBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            init_inputs();
            ForwardRSD = 3'd3;
            ForwardRTD = 3'd3;
            #1;

            check_outputs(32'hCCCC_CCCC, 32'hCCCC_CCCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            init_inputs();
            ForwardRSD = 3'd4;
            ForwardRTD = 3'd4;
            #1;

            check_outputs(32'hDDDD_DDDD, 32'hDDDD_DDDD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            init_inputs();
            ForwardRSD = 3'd5;
            ForwardRTD = 3'd5;
            #1;

            check_outputs(32'hEEEE_EEEE, 32'hEEEE_EEEE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            init_inputs();
            ForwardRSD = 3'd6;
            ForwardRTD = 3'd6;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            init_inputs();
            ForwardRSD = 3'd1;
            ForwardRTD = 3'd4;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'hDDDD_DDDD);
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
        input [31:0] expected_D1;
        input [31:0] expected_D2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D1 === (expected_D1 ^ D1 ^ expected_D1) &&
                expected_D2 === (expected_D2 ^ D2 ^ expected_D2)) begin
                $display("PASS");
                $display("  Outputs: D1=%h, D2=%h",
                         D1, D2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D1=%h, D2=%h",
                         expected_D1, expected_D2);
                $display("  Got:      D1=%h, D2=%h",
                         D1, D2);
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
