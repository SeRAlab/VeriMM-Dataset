`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] instr_imm_i;
    wire [31:0] sign_extnd_instr_imm_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instr_imm_i(instr_imm_i),
        .sign_extnd_instr_imm_o(sign_extnd_instr_imm_o)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All Zeros", test_num);
        instr_imm_i = 20'h00000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: All Ones (Sign Extended Negative)", test_num);
        instr_imm_i = 20'hFFFFF;
        #1;

        check_outputs(32'hFFFFFFFE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Small Positive Value", test_num);
        instr_imm_i = 20'h00001;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Maximum Positive Value (MSB 0)", test_num);
        instr_imm_i = 20'h7FFFF;
        #1;

        check_outputs(32'h000FFFFE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Minimum Negative Value (MSB 1)", test_num);
        instr_imm_i = 20'h80000;
        #1;

        check_outputs(32'hFFF00000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Negative Value close to Minimum", test_num);
        instr_imm_i = 20'h80001;
        #1;

        check_outputs(32'hFFF00002);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Pattern 0xAAAAA (Sign bit 1)", test_num);
        instr_imm_i = 20'hAAAAA;
        #1;

        check_outputs(32'hFFFF5554);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Pattern 0x55555 (Sign bit 0)", test_num);
        instr_imm_i = 20'h55555;
        #1;

        check_outputs(32'h000AAAAA);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Random bit mixture (Sign bit 0)", test_num);
        instr_imm_i = 20'h12345;

        #1;


        check_outputs(32'h0002468A);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Random bit mixture (Sign bit 1)", test_num);
        instr_imm_i = 20'hC9B3D;



        #1;




        check_outputs(32'hFFF9367A);
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
        input [31:0] expected_sign_extnd_instr_imm_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sign_extnd_instr_imm_o === (expected_sign_extnd_instr_imm_o ^ sign_extnd_instr_imm_o ^ expected_sign_extnd_instr_imm_o)) begin
                $display("PASS");
                $display("  Outputs: sign_extnd_instr_imm_o=%h",
                         sign_extnd_instr_imm_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sign_extnd_instr_imm_o=%h",
                         expected_sign_extnd_instr_imm_o);
                $display("  Got:      sign_extnd_instr_imm_o=%h",
                         sign_extnd_instr_imm_o);
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
