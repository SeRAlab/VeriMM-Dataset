`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ALU_N;
    reg [7:0] ALU_OUT;
    reg [12:0] IR_ADDR;
    wire [7:0] OUT_DATA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_N(ALU_N),
        .ALU_OUT(ALU_OUT),
        .IR_ADDR(IR_ADDR),
        .OUT_DATA(OUT_DATA)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_N=0, should select ALU_OUT", test_num);
        ALU_N = 1'b0;
        ALU_OUT = 8'h55;
        IR_ADDR = 13'h1AAA;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_N=1, should select IR_ADDR LSBs", test_num);
        ALU_N = 1'b1;
        ALU_OUT = 8'h55;
        IR_ADDR = 13'h1A5;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_N=0, ALU_OUT=FF", test_num);
        ALU_N = 1'b0;
        ALU_OUT = 8'hFF;
        IR_ADDR = 13'h000;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_N=1, IR_ADDR with all bits set", test_num);
        ALU_N = 1'b1;
        ALU_OUT = 8'h00;
        IR_ADDR = 13'h1FFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_N=0, ALU_OUT=00", test_num);
        ALU_N = 1'b0;
        ALU_OUT = 8'h00;
        IR_ADDR = 13'h1FF;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_N=1, testing high bits of IR_ADDR do not affect 8-bit output", test_num);
        ALU_N = 1'b1;
        ALU_OUT = 8'hAA;
        IR_ADDR = 13'h10F;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_N toggle test (switching to ALU_OUT)", test_num);
        ALU_N = 1'b0;
        ALU_OUT = 8'h3C;
        IR_ADDR = 13'h0F0;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ALU_N toggle test (switching to IR_ADDR)", test_num);
        ALU_N = 1'b1;
        ALU_OUT = 8'h3C;
        IR_ADDR = 13'h0F0;
        #1;

        check_outputs(8'hF0);
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
        input [7:0] expected_OUT_DATA;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT_DATA === (expected_OUT_DATA ^ OUT_DATA ^ expected_OUT_DATA)) begin
                $display("PASS");
                $display("  Outputs: OUT_DATA=%h",
                         OUT_DATA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT_DATA=%h",
                         expected_OUT_DATA);
                $display("  Got:      OUT_DATA=%h",
                         OUT_DATA);
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
