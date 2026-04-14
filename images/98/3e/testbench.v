`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg [31:0] CurPC;
    reg [31:0] ExtOut;
    reg [25:0] JumpAddr;
    reg [1:0] PCSrc;
    wire [31:0] newPC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CurPC(CurPC),
        .ExtOut(ExtOut),
        .JumpAddr(JumpAddr),
        .PCSrc(PCSrc),
        .newPC(newPC)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Sequential PC Increment", test_num);


        PCSrc = 2'b00;
        CurPC = 32'h00000000;
        ExtOut = 32'h00000000;
        JumpAddr = 26'h0000000;


        @(posedge CLK);
        #1;


        #1;



        check_outputs(32'h00000004);
    end
    endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Sequential PC Increment (Non-zero PC)", test_num);

        PCSrc = 2'b00;
        CurPC = 32'h12345678;

        @(posedge CLK);
        #1;


        #1;



        check_outputs(32'h1234567C);
    end
    endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Branch Logic (Positive Offset)", test_num);

        PCSrc = 2'b01;
        CurPC = 32'h00001000;
        ExtOut = 32'h00000005;

        @(posedge CLK);
        #1;


        #1;



        check_outputs(32'h00001018);
    end
    endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Branch Logic (Negative Offset)", test_num);

        PCSrc = 2'b01;
        CurPC = 32'h00001000;
        ExtOut = 32'hFFFFFFFF;

        @(posedge CLK);
        #1;


        #1;



        check_outputs(32'h00001000);
    end
    endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Jump Logic", test_num);

        PCSrc = 2'b10;
        CurPC = 32'h20000000;
        JumpAddr = 26'h0123456;

        @(posedge CLK);
        #1;




        #1;





        check_outputs(32'h2048D158);
    end
    endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Jump Logic at Page Boundary", test_num);

        PCSrc = 2'b10;
        CurPC = 32'h0FFFFFFC;
        JumpAddr = 26'h0000001;

        @(posedge CLK);
        #1;





        #1;






        check_outputs(32'h10000004);
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
        input [31:0] expected_newPC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_newPC === (expected_newPC ^ newPC ^ expected_newPC)) begin
                $display("PASS");
                $display("  Outputs: newPC=%h",
                         newPC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: newPC=%h",
                         expected_newPC);
                $display("  Got:      newPC=%h",
                         newPC);
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
