`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg and_en_i;
    reg cflag_i;
    reg [63:0] inA_i;
    reg [63:0] inB_i;
    reg invB_en_i;
    reg lsh_en_i;
    reg lts_en_i;
    reg ltu_en_i;
    reg rsh_en_i;
    reg sum_en_i;
    reg xor_en_i;
    wire cflag_o;
    wire [63:0] out_o;
    wire vflag_o;
    wire zflag_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .and_en_i(and_en_i),
        .cflag_i(cflag_i),
        .inA_i(inA_i),
        .inB_i(inB_i),
        .invB_en_i(invB_en_i),
        .lsh_en_i(lsh_en_i),
        .lts_en_i(lts_en_i),
        .ltu_en_i(ltu_en_i),
        .rsh_en_i(rsh_en_i),
        .sum_en_i(sum_en_i),
        .xor_en_i(xor_en_i),
        .cflag_o(cflag_o),
        .out_o(out_o),
        .vflag_o(vflag_o),
        .zflag_o(zflag_o)
    );
    task clear_signals;

        begin
            and_en_i  = 0;
            cflag_i   = 0;
            inA_i     = 0;
            inB_i     = 0;
            invB_en_i = 0;
            lsh_en_i  = 0;
            lts_en_i  = 0;
            ltu_en_i  = 0;
            rsh_en_i  = 0;
            sum_en_i  = 0;
            xor_en_i  = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            clear_signals();
            inA_i = 64'h0000_0000_0000_0005;
            inB_i = 64'h0000_0000_0000_0003;
            sum_en_i = 1;
            #1;

            check_outputs(1'b0, 64'h0000_0000_0000_0008, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            clear_signals();
            inA_i = 64'hFFFF_FFFF_FFFF_FFFF;
            inB_i = 64'h0000_0000_0000_0001;
            sum_en_i = 1;
            #1;

            check_outputs(1'b1, 64'h0000_0000_0000_0000, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            clear_signals();
            inA_i = 64'h7FFF_FFFF_FFFF_FFFF;
            inB_i = 64'h0000_0000_0000_0001;
            sum_en_i = 1;

            #1;


            check_outputs(1'b0, 64'h8000_0000_0000_0000, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            clear_signals();
            inA_i = 64'h0000_0000_0000_000A;
            inB_i = 64'h0000_0000_0000_0004;
            invB_en_i = 1;
            cflag_i = 1;
            sum_en_i = 1;

            #1;


            check_outputs(1'b1, 64'h0000_0000_0000_0006, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            clear_signals();
            inA_i = 64'hAAAA_AAAA_AAAA_AAAA;
            inB_i = 64'h5555_5555_5555_5555;
            and_en_i = 1;
            #1;

            check_outputs(1'b0, 64'h0000_0000_0000_0000, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            clear_signals();
            inA_i = 64'hF0F0_F0F0_F0F0_F0F0;
            inB_i = 64'hFFFF_FFFF_FFFF_FFFF;
            xor_en_i = 1;
            #1;

            check_outputs(1'b0, 64'h0F0F_0F0F_0F0F_0F0F, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            clear_signals();
            inA_i = 64'h0000_0000_0000_000F;
            inB_i = 64'h0000_0000_0000_0004;
            lsh_en_i = 1;
            #1;

            check_outputs(1'b0, 64'h0000_0000_0000_00F0, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            clear_signals();
            inA_i = 64'hF000_0000_0000_0000;
            inB_i = 64'h0000_0000_0000_0004;
            rsh_en_i = 1;
            #1;

            check_outputs(1'b0, 64'h0F00_0000_0000_0000, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            clear_signals();
            inA_i = 64'h0000_0000_0000_0005;
            inB_i = 64'hFFFF_FFFF_FFFF_FFFF;
            ltu_en_i = 1;
            #1;

            check_outputs(1'b0, 64'h0000_0000_0000_0001, 1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            clear_signals();
            inA_i = 64'hFFFF_FFFF_FFFF_FFFF;
            inB_i = 64'h0000_0000_0000_0001;
            lts_en_i = 1;
            #1;

            check_outputs(1'b0, 64'h0000_0000_0000_0001, 1'b0, 1'b0);
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
        input expected_cflag_o;
        input [63:0] expected_out_o;
        input expected_vflag_o;
        input expected_zflag_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cflag_o === (expected_cflag_o ^ cflag_o ^ expected_cflag_o) &&
                expected_out_o === (expected_out_o ^ out_o ^ expected_out_o) &&
                expected_vflag_o === (expected_vflag_o ^ vflag_o ^ expected_vflag_o) &&
                expected_zflag_o === (expected_zflag_o ^ zflag_o ^ expected_zflag_o)) begin
                $display("PASS");
                $display("  Outputs: cflag_o=%b, out_o=%h, vflag_o=%b, zflag_o=%b",
                         cflag_o, out_o, vflag_o, zflag_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cflag_o=%b, out_o=%h, vflag_o=%b, zflag_o=%b",
                         expected_cflag_o, expected_out_o, expected_vflag_o, expected_zflag_o);
                $display("  Got:      cflag_o=%b, out_o=%h, vflag_o=%b, zflag_o=%b",
                         cflag_o, out_o, vflag_o, zflag_o);
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
