`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] instruction;
    wire addi;
    wire br;
    wire brz;
    wire clr;
    wire mov;
    wire mova;
    wire movr;
    wire movrhs;
    wire pause;
    wire sr0;
    wire srh0;
    wire subi;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .instruction(instruction),
        .addi(addi),
        .br(br),
        .brz(brz),
        .clr(clr),
        .mov(mov),
        .mova(mova),
        .movr(movr),
        .movrhs(movrhs),
        .pause(pause),
        .sr0(sr0),
        .srh0(srh0),
        .subi(subi)
    );
    task testcase001;

    begin
        test_num = 1;
        instruction = 6'b000001;

        #1;


        check_outputs(0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        instruction = 6'b000010;

        #1;


        check_outputs(0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        instruction = 6'b000011;

        #1;


        check_outputs(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        instruction = 6'b000100;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        instruction = 6'b000101;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        instruction = 6'b000110;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        instruction = 6'b000111;

        #1;


        check_outputs(0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        instruction = 6'b001000;

        #1;


        check_outputs(0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        instruction = 6'b001001;

        #1;


        check_outputs(0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        instruction = 6'b001010;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        instruction = 6'b001011;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        instruction = 6'b001100;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        instruction = 6'b000000;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        instruction = 6'b111111;

        #1;


        check_outputs(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
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
        testcase012();
        testcase013();
        testcase014();
        
        
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
        input expected_addi;
        input expected_br;
        input expected_brz;
        input expected_clr;
        input expected_mov;
        input expected_mova;
        input expected_movr;
        input expected_movrhs;
        input expected_pause;
        input expected_sr0;
        input expected_srh0;
        input expected_subi;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addi === (expected_addi ^ addi ^ expected_addi) &&
                expected_br === (expected_br ^ br ^ expected_br) &&
                expected_brz === (expected_brz ^ brz ^ expected_brz) &&
                expected_clr === (expected_clr ^ clr ^ expected_clr) &&
                expected_mov === (expected_mov ^ mov ^ expected_mov) &&
                expected_mova === (expected_mova ^ mova ^ expected_mova) &&
                expected_movr === (expected_movr ^ movr ^ expected_movr) &&
                expected_movrhs === (expected_movrhs ^ movrhs ^ expected_movrhs) &&
                expected_pause === (expected_pause ^ pause ^ expected_pause) &&
                expected_sr0 === (expected_sr0 ^ sr0 ^ expected_sr0) &&
                expected_srh0 === (expected_srh0 ^ srh0 ^ expected_srh0) &&
                expected_subi === (expected_subi ^ subi ^ expected_subi)) begin
                $display("PASS");
                $display("  Outputs: addi=%b, br=%b, brz=%b, clr=%b, mov=%b, mova=%b, movr=%b, movrhs=%b, pause=%b, sr0=%b, srh0=%b, subi=%b",
                         addi, br, brz, clr, mov, mova, movr, movrhs, pause, sr0, srh0, subi);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addi=%b, br=%b, brz=%b, clr=%b, mov=%b, mova=%b, movr=%b, movrhs=%b, pause=%b, sr0=%b, srh0=%b, subi=%b",
                         expected_addi, expected_br, expected_brz, expected_clr, expected_mov, expected_mova, expected_movr, expected_movrhs, expected_pause, expected_sr0, expected_srh0, expected_subi);
                $display("  Got:      addi=%b, br=%b, brz=%b, clr=%b, mov=%b, mova=%b, movr=%b, movrhs=%b, pause=%b, sr0=%b, srh0=%b, subi=%b",
                         addi, br, brz, clr, mov, mova, movr, movrhs, pause, sr0, srh0, subi);
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
