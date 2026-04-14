`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [63:0] rs1_data;
    reg [63:0] rs2_data;
    wire [63:0] spr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .spr_out(spr_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: All zeros, cin=0");
            test_num = 1;
            rs1_data = 64'h0;
            rs2_data = 64'h0;
            cin = 1'b0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All zeros, cin=1");
            test_num = 2;
            rs1_data = 64'h0;
            rs2_data = 64'h0;
            cin = 1'b1;
            #1;

            check_outputs(64'h1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: All ones, cin=0");
            test_num = 3;



            rs1_data = 64'hFFFFFFFFFFFFFFFF;
            rs2_data = 64'hFFFFFFFFFFFFFFFF;
            cin = 1'b0;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFE);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: All ones, cin=1");
            test_num = 4;



            rs1_data = 64'hFFFFFFFFFFFFFFFF;
            rs2_data = 64'hFFFFFFFFFFFFFFFF;
            cin = 1'b1;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: rs1 all ones, rs2 all zeros, cin=0");
            test_num = 5;




            rs1_data = 64'hFFFFFFFFFFFFFFFF;
            rs2_data = 64'h0;
            cin = 1'b0;
            #1;

            check_outputs(64'h1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Bit 63 toggled, lower bits zero, cin=0");
            test_num = 6;



            rs1_data = 64'h8000000000000000;
            rs2_data = 64'h0;
            cin = 1'b0;
            #1;

            check_outputs(64'h8000000000000000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Alternating bits pattern");
            test_num = 7;




            rs1_data = 64'hAAAAAAAAAAAAAAAA;
            rs2_data = 64'h5555555555555555;
            cin = 1'b1;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Bitwise OR vs XOR interaction");
            test_num = 8;





            rs1_data = 64'h3;
            rs2_data = 64'h0;
            cin = 1'b0;
            #1;

            check_outputs(64'h5);
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
        input [63:0] expected_spr_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_spr_out === (expected_spr_out ^ spr_out ^ expected_spr_out)) begin
                $display("PASS");
                $display("  Outputs: spr_out=%h",
                         spr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: spr_out=%h",
                         expected_spr_out);
                $display("  Got:      spr_out=%h",
                         spr_out);
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
