`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] func;
    reg [31:0] in1;
    reg [31:0] in2;
    wire [31:0] aluout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .func(func),
        .in1(in1),
        .in2(in2),
        .aluout(aluout)
    );
    task testcase001;

    begin
        test_num = 1;
        func = 4'b0000; in1 = 32'hAAAA_AAAA; in2 = 32'hF0F0_F0F0;
        $display("Test %0d: Bitwise AND", test_num);
        #1;

        check_outputs(32'hA0A0_A0A0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        func = 4'b0001; in1 = 32'hAAAA_AAAA; in2 = 32'h5555_5555;
        $display("Test %0d: Bitwise OR", test_num);
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        func = 4'b0010; in1 = 32'h1234_5678; in2 = 32'hFFFF_FFFF;
        $display("Test %0d: Bitwise XOR", test_num);
        #1;

        check_outputs(32'hEDCB_A987);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        func = 4'b0011; in1 = 32'h1234_5678; in2 = 32'h1234_5678;
        $display("Test %0d: Bitwise XNOR", test_num);
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        func = 4'b0100; in1 = 32'd100; in2 = 32'd250;
        $display("Test %0d: Addition", test_num);
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        func = 4'b1100; in1 = 32'd500; in2 = 32'd200;
        $display("Test %0d: Subtraction (Arithmetic Inversion)", test_num);
        #1;

        check_outputs(32'd300);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        func = 4'b1110; in1 = 32'd10; in2 = 32'd20;
        $display("Test %0d: Less Than (True)", test_num);

        #1;


        check_outputs(32'h0000_0001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        func = 4'b1110; in1 = 32'd50; in2 = 32'd20;
        $display("Test %0d: Less Than (False)", test_num);
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        func = 4'b1101; in1 = 32'd0; in2 = 32'd1;


        $display("Test %0d: Sign Extension of Result", test_num);
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        func = 4'b0100; in1 = 32'hFFFF_FFFF; in2 = 32'd1;
        $display("Test %0d: Overflow Addition (32-bit wrap)", test_num);
        #1;

        check_outputs(32'h0000_0000);
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
        input [31:0] expected_aluout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluout === (expected_aluout ^ aluout ^ expected_aluout)) begin
                $display("PASS");
                $display("  Outputs: aluout=%h",
                         aluout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluout=%h",
                         expected_aluout);
                $display("  Got:      aluout=%h",
                         aluout);
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
