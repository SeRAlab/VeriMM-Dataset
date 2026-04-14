`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Addr;
    reg [7:0] In0;
    reg [7:0] In1;
    reg [7:0] In2;
    reg [7:0] In3;
    reg [7:0] In4;
    reg [7:0] In5;
    reg [7:0] In6;
    reg [7:0] In7;
    wire [31:0] DOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Addr(Addr),
        .In0(In0),
        .In1(In1),
        .In2(In2),
        .In3(In3),
        .In4(In4),
        .In5(In5),
        .In6(In6),
        .In7(In7),
        .DOut(DOut)
    );
    task testcase001;

    begin
        test_num = 1;
        Addr = 1'b0;
        In0 = 8'h00; In1 = 8'h00; In2 = 8'h00; In3 = 8'h00;
        In4 = 8'hFF; In5 = 8'hFF; In6 = 8'hFF; In7 = 8'hFF;
        $display("Test %0d: Addr=0, In0-3=0x00 (Expect DOut=0xFFFFFFFF)", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Addr = 1'b0;
        In0 = 8'hFF; In1 = 8'hFF; In2 = 8'hFF; In3 = 8'hFF;
        In4 = 8'h00; In5 = 8'h00; In6 = 8'h00; In7 = 8'h00;
        $display("Test %0d: Addr=0, In0-3=0xFF (Expect DOut=0x00000000)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Addr = 1'b0;
        In0 = 8'h12; In1 = 8'h34; In2 = 8'h56; In3 = 8'h78;
        In4 = 8'h00; In5 = 8'h00; In6 = 8'h00; In7 = 8'h00;
        $display("Test %0d: Addr=0, In0-3=0x12345678 (Expect DOut=0xEDCBA987)", test_num);
        #1;

        check_outputs(~32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Addr = 1'b1;
        In0 = 8'hFF; In1 = 8'hFF; In2 = 8'hFF; In3 = 8'hFF;
        In4 = 8'h00; In5 = 8'h00; In6 = 8'h00; In7 = 8'h00;
        $display("Test %0d: Addr=1, In4-7=0x00 (Expect DOut=0xFFFFFFFF)", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Addr = 1'b1;
        In0 = 8'h00; In1 = 8'h00; In2 = 8'h00; In3 = 8'h00;
        In4 = 8'hFF; In5 = 8'hFF; In6 = 8'hFF; In7 = 8'hFF;
        $display("Test %0d: Addr=1, In4-7=0xFF (Expect DOut=0x00000000)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Addr = 1'b1;
        In0 = 8'h00; In1 = 8'h00; In2 = 8'h00; In3 = 8'h00;
        In4 = 8'hDE; In5 = 8'hAD; In6 = 8'hBE; In7 = 8'hEF;
        $display("Test %0d: Addr=1, In4-7=0xDEADBEEF (Expect DOut=0x21524110)", test_num);
        #1;

        check_outputs(~32'hDEADBEEF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Addr = 1'b0;
        In0 = 8'hAA; In1 = 8'h55; In2 = 8'hAA; In3 = 8'h55;
        In4 = 8'hCC; In5 = 8'h33; In6 = 8'hCC; In7 = 8'h33;
        $display("Test %0d: Addr=0 Toggle, In0-3=0xAA55AA55 (Expect DOut=0x55AA55AA)", test_num);
        #1;

        check_outputs(~32'hAA55AA55);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Addr = 1'b1;

        $display("Test %0d: Addr=1 Toggle, In4-7=0xCC33CC33 (Expect DOut=0x33CC33CC)", test_num);
        #1;

        check_outputs(~32'hCC33CC33);
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
        input [31:0] expected_DOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DOut === (expected_DOut ^ DOut ^ expected_DOut)) begin
                $display("PASS");
                $display("  Outputs: DOut=%h",
                         DOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOut=%h",
                         expected_DOut);
                $display("  Got:      DOut=%h",
                         DOut);
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
