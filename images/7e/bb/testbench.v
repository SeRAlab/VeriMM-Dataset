`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ACK_I;
    reg CLK_I;
    reg CYC_I;
    reg [31:0] DAT_I;
    reg RST_I;
    reg STB_I;
    reg WE_I;
    wire ACK_O;
    wire CYC_O;
    wire [31:0] DAT_O;
    wire STB_O;
    wire WE_O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ACK_I(ACK_I),
        .CLK_I(CLK_I),
        .CYC_I(CYC_I),
        .DAT_I(DAT_I),
        .RST_I(RST_I),
        .STB_I(STB_I),
        .WE_I(WE_I),
        .ACK_O(ACK_O),
        .CYC_O(CYC_O),
        .DAT_O(DAT_O),
        .STB_O(STB_O),
        .WE_O(WE_O)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset and Initial State logic", test_num);


        RST_I = 1;
        DAT_I = 32'h0; WE_I = 0; STB_I = 0; CYC_I = 0; ACK_I = 0;
        @(posedge CLK_I);
        #2;
        RST_I = 0;
        @(posedge CLK_I);


        #1;



        check_outputs(1'b0, 1'b0, 32'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write transaction pass-through", test_num);

        RST_I = 1; #10; RST_I = 0; #10;

        DAT_I = 32'hDEADBEEF;
        WE_I = 1;
        STB_I = 1;
        CYC_I = 1;
        ACK_I = 0;

        @(posedge CLK_I);
        #2;
        #1;

        check_outputs(1'b0, 1'b1, 32'hDEADBEEF, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Read transaction with ACK feedback", test_num);

        RST_I = 1; #10; RST_I = 0; #10;

        DAT_I = 32'hCAFEBABE;
        WE_I = 0;
        STB_I = 1;
        CYC_I = 1;
        ACK_I = 1;

        @(posedge CLK_I);
        #2;
        #1;

        check_outputs(1'b1, 1'b1, 32'hCAFEBABE, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating bit pattern verification", test_num);

        RST_I = 1; #10; RST_I = 0; #10;

        DAT_I = 32'h5555AAAA;
        WE_I = 1;
        STB_I = 0;
        CYC_I = 1;
        ACK_I = 0;

        @(posedge CLK_I);
        #2;
        #1;

        check_outputs(1'b0, 1'b1, 32'h5555AAAA, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Idle state de-assertion", test_num);

        RST_I = 1; #10; RST_I = 0; #10;

        DAT_I = 32'h00000000;
        WE_I = 0;
        STB_I = 0;
        CYC_I = 0;
        ACK_I = 0;

        @(posedge CLK_I);
        #2;
        #1;

        check_outputs(1'b0, 1'b0, 32'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All signals high", test_num);

        RST_I = 1; #10; RST_I = 0; #10;

        DAT_I = 32'hFFFFFFFF;
        WE_I = 1;
        STB_I = 1;
        CYC_I = 1;
        ACK_I = 1;

        @(posedge CLK_I);
        #2;
        #1;

        check_outputs(1'b1, 1'b1, 32'hFFFFFFFF, 1'b1, 1'b1);
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
        input expected_ACK_O;
        input expected_CYC_O;
        input [31:0] expected_DAT_O;
        input expected_STB_O;
        input expected_WE_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ACK_O === (expected_ACK_O ^ ACK_O ^ expected_ACK_O) &&
                expected_CYC_O === (expected_CYC_O ^ CYC_O ^ expected_CYC_O) &&
                expected_DAT_O === (expected_DAT_O ^ DAT_O ^ expected_DAT_O) &&
                expected_STB_O === (expected_STB_O ^ STB_O ^ expected_STB_O) &&
                expected_WE_O === (expected_WE_O ^ WE_O ^ expected_WE_O)) begin
                $display("PASS");
                $display("  Outputs: ACK_O=%b, CYC_O=%b, DAT_O=%h, STB_O=%b, WE_O=%b",
                         ACK_O, CYC_O, DAT_O, STB_O, WE_O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ACK_O=%b, CYC_O=%b, DAT_O=%h, STB_O=%b, WE_O=%b",
                         expected_ACK_O, expected_CYC_O, expected_DAT_O, expected_STB_O, expected_WE_O);
                $display("  Got:      ACK_O=%b, CYC_O=%b, DAT_O=%h, STB_O=%b, WE_O=%b",
                         ACK_O, CYC_O, DAT_O, STB_O, WE_O);
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
