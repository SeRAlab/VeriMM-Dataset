`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Address;
    reg LoadUnsigned;
    reg [31:0] MemOut;
    reg [1:0] MemSize;
    wire [31:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address(Address),
        .LoadUnsigned(LoadUnsigned),
        .MemOut(MemOut),
        .MemSize(MemSize),
        .Result(Result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Byte Load Unsigned (Byte 0)", test_num);
        MemOut = 32'hAABBCC85;
        MemSize = 2'b00;
        LoadUnsigned = 1'b1;
        Address = 32'h00000000;
        #1;

        check_outputs(32'h00000085);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Byte Load Signed (Byte 0 - Negative)", test_num);
        MemOut = 32'hAABBCC85;
        MemSize = 2'b00;
        LoadUnsigned = 1'b0;
        Address = 32'h00000000;
        #1;

        check_outputs(32'hFFFFFF85);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Byte Load Signed (Byte 1 - Positive)", test_num);
        MemOut = 32'hAABB4C85;
        MemSize = 2'b00;
        LoadUnsigned = 1'b0;
        Address = 32'h00000001;
        #1;

        check_outputs(32'h0000004C);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Byte Load Unsigned (Byte 2)", test_num);
        MemOut = 32'hAA9BCC85;
        MemSize = 2'b00;
        LoadUnsigned = 1'b1;
        Address = 32'h00000002;
        #1;

        check_outputs(32'h0000009B);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Byte Load Signed (Byte 3 - Negative)", test_num);
        MemOut = 32'hF0BBCC85;
        MemSize = 2'b00;
        LoadUnsigned = 1'b0;
        Address = 32'h00000003;
        #1;

        check_outputs(32'hFFFFFFF0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Halfword Load Unsigned (Lower)", test_num);
        MemOut = 32'h12348001;
        MemSize = 2'b01;
        LoadUnsigned = 1'b1;
        Address = 32'h00000000;
        #1;

        check_outputs(32'h00008001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Halfword Load Signed (Lower - Negative)", test_num);
        MemOut = 32'h12348001;
        MemSize = 2'b01;
        LoadUnsigned = 1'b0;
        Address = 32'h00000000;
        #1;

        check_outputs(32'hFFFF8001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Halfword Load Signed (Upper - Positive)", test_num);
        MemOut = 32'h72348001;
        MemSize = 2'b01;
        LoadUnsigned = 1'b0;
        Address = 32'h00000002;
        #1;

        check_outputs(32'h00007234);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Halfword Load Signed (Upper - Negative)", test_num);
        MemOut = 32'hF2348001;
        MemSize = 2'b01;
        LoadUnsigned = 1'b0;
        Address = 32'h00000002;
        #1;

        check_outputs(32'hFFFFF234);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Word Load", test_num);
        MemOut = 32'hDEADBEEF;
        MemSize = 2'b10;
        LoadUnsigned = 1'b0;
        Address = 32'h00000000;
        #1;

        check_outputs(32'hDEADBEEF);
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
        input [31:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Result=%h",
                         Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h",
                         expected_Result);
                $display("  Got:      Result=%h",
                         Result);
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
