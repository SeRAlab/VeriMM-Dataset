`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a_in;
    reg [3:0] alu_function;
    reg [31:0] b_in;
    wire [31:0] c_alu;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_in(a_in),
        .alu_function(alu_function),
        .b_in(b_in),
        .c_alu(c_alu)
    );
    task testcase001;

    begin
        test_num = 1;
        a_in = 32'd100;
        b_in = 32'd250;
        alu_function = 4'b0000;
        $display("Testcase %0d: Addition (100 + 250)", test_num);
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a_in = 32'hFFFFFFFF;
        b_in = 32'h00000001;
        alu_function = 4'b0000;
        $display("Testcase %0d: Addition (-1 + 1)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a_in = 32'd500;
        b_in = 32'd200;
        alu_function = 4'b0001;
        $display("Testcase %0d: Subtraction (500 - 200)", test_num);
        #1;

        check_outputs(32'd300);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a_in = 32'd10;
        b_in = 32'd20;
        alu_function = 4'b0001;
        $display("Testcase %0d: Subtraction (10 - 20)", test_num);
        #1;

        check_outputs(32'hFFFFFFF6);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a_in = 32'hAAAA_5555;
        b_in = 32'hFFFF_0000;
        alu_function = 4'b0010;
        $display("Testcase %0d: Logical AND", test_num);
        #1;

        check_outputs(32'hAAAA_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a_in = 32'hAAAA_5555;
        b_in = 32'h5555_AAAA;
        alu_function = 4'b0011;
        $display("Testcase %0d: Logical OR", test_num);
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a_in = 32'hF0F0_F0F0;
        b_in = 32'hFFFF_FFFF;
        alu_function = 4'b0100;
        $display("Testcase %0d: Logical XOR", test_num);
        #1;

        check_outputs(32'h0F0F_0F0F);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a_in = 32'h0000_0000;
        b_in = 32'h0000_0000;
        alu_function = 4'b0101;
        $display("Testcase %0d: Logical NOR (0 NOR 0)", test_num);
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a_in = 32'hFFFF_FFFF;
        b_in = 32'h0000_0001;
        alu_function = 4'b0110;
        $display("Testcase %0d: SLT (-1 < 1)", test_num);
        #1;

        check_outputs(32'h0000_0001);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a_in = 32'h0000_0005;
        b_in = 32'hFFFF_FFF6;
        alu_function = 4'b0110;
        $display("Testcase %0d: SLT (5 < -10)", test_num);
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        a_in = 32'hFFFF_FFFF;
        b_in = 32'hFFFF_FFFF;
        alu_function = 4'b1111;
        $display("Testcase %0d: Invalid Function Selector (Default to 0)", test_num);
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
        testcase011();
        
        
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
        input [31:0] expected_c_alu;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c_alu === (expected_c_alu ^ c_alu ^ expected_c_alu)) begin
                $display("PASS");
                $display("  Outputs: c_alu=%h",
                         c_alu);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_alu=%h",
                         expected_c_alu);
                $display("  Got:      c_alu=%h",
                         c_alu);
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
