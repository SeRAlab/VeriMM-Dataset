`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Cin;
    reg [15:0] G;
    reg [15:0] P;
    wire [3:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cin(Cin),
        .G(G),
        .P(P),
        .C(C)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        Cin = 0; G = 16'h0000; P = 16'h0000;
        #10;
        $display("Testcase %0d: All Zeros", test_num);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        Cin = 1; G = 16'h0000; P = 16'hFFFF;
        #10;
        $display("Testcase %0d: Cin propagation through all blocks", test_num);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        Cin = 0; G = 16'h8888; P = 16'h0000;
        #10;
        $display("Testcase %0d: Direct group generation (MSB of nibbles)", test_num);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;

        Cin = 0; G = 16'h0001; P = 16'h000E;
        #10;
        $display("Testcase %0d: Internal group generation (Bit 0 to C[0])", test_num);
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        Cin = 0; G = 16'h0008; P = 16'hFFF0;
        #10;
        $display("Testcase %0d: Carry ripple from Block 0 through Block 3", test_num);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        Cin = 1; G = 16'h0000; P = 16'h00FF;
        #10;
        $display("Testcase %0d: Cin propagation limited to C[0] and C[1]", test_num);
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        Cin = 0; G = 16'h0800; P = 16'hF000;
        #10;
        $display("Testcase %0d: Block 2 generates, ripples to C[3]", test_num);
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;


        Cin = 0; G = 16'h8804; P = 16'h0008;
        #10;
        $display("Testcase %0d: Sparse signal verification", test_num);
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        Cin = 1; G = 16'h0000; P = 16'hEEEE;
        #10;
        $display("Testcase %0d: Cin blocked by P=0 at nibble boundaries", test_num);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        Cin = 1; G = 16'hFFFF; P = 16'hFFFF;
        #10;
        $display("Testcase %0d: All inputs high", test_num);
        #1;

        check_outputs(4'hF);
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
        input [3:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
