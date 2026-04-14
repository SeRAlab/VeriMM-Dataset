`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ALUOut_W;
    reg [2:0] ExtDM_W;
    reg [31:0] ReadData_W;
    wire [31:0] ReadData_W_R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOut_W(ALUOut_W),
        .ExtDM_W(ExtDM_W),
        .ReadData_W(ReadData_W),
        .ReadData_W_R(ReadData_W_R)
    );
    task testcase001;

    begin
        test_num = 1;
        ALUOut_W = 2'b00;
        ReadData_W = 32'hA5B6C7D8;
        ExtDM_W = 3'b010;
        #10;
        #1;

        check_outputs(32'hA5B6C7D8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ALUOut_W = 2'b00;
        ReadData_W = 32'h12345650;
        ExtDM_W = 3'b000;
        #10;
        #1;

        check_outputs(32'h00000050);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ALUOut_W = 2'b00;
        ReadData_W = 32'h12345680;
        ExtDM_W = 3'b000;
        #10;
        #1;

        check_outputs(32'hFFFFFF80);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ALUOut_W = 2'b00;
        ReadData_W = 32'h12345680;
        ExtDM_W = 3'b011;
        #10;
        #1;

        check_outputs(32'h00000080);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ALUOut_W = 2'b11;
        ReadData_W = 32'hA0345678;
        ExtDM_W = 3'b000;
        #10;
        #1;

        check_outputs(32'hFFFFFFA0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ALUOut_W = 2'b00;
        ReadData_W = 32'hABCD1234;
        ExtDM_W = 3'b001;
        #10;
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        ALUOut_W = 2'b00;
        ReadData_W = 32'hABCD8234;
        ExtDM_W = 3'b001;
        #10;
        #1;

        check_outputs(32'hFFFF8234);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        ALUOut_W = 2'b10;
        ReadData_W = 32'hABCD1234;
        ExtDM_W = 3'b100;
        #10;
        #1;

        check_outputs(32'h0000ABCD);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        ALUOut_W = 2'b01;
        ReadData_W = 32'hAABBCCDD;
        ExtDM_W = 3'b000;
        #10;
        #1;

        check_outputs(32'hFFFFFFCC);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        ALUOut_W = 2'b00;
        ReadData_W = 32'hFFFFFFFF;
        ExtDM_W = 3'b010;
        #10;
        #1;

        check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_ReadData_W_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ReadData_W_R === (expected_ReadData_W_R ^ ReadData_W_R ^ expected_ReadData_W_R)) begin
                $display("PASS");
                $display("  Outputs: ReadData_W_R=%h",
                         ReadData_W_R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ReadData_W_R=%h",
                         expected_ReadData_W_R);
                $display("  Got:      ReadData_W_R=%h",
                         ReadData_W_R);
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
