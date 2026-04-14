`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg A3;
    reg A4;
    reg ACCESO_2;
    reg ATRAS;
    reg B1;
    reg B2;
    reg B3;
    reg B4;
    reg s0_1;
    reg s1_1;
    wire ACCESO_1;
    wire Solicitar_Pin;
    wire Solicitar_Tarjeta;
    wire sf0_1;
    wire sf1_1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .A4(A4),
        .ACCESO_2(ACCESO_2),
        .ATRAS(ATRAS),
        .B1(B1),
        .B2(B2),
        .B3(B3),
        .B4(B4),
        .s0_1(s0_1),
        .s1_1(s1_1),
        .ACCESO_1(ACCESO_1),
        .Solicitar_Pin(Solicitar_Pin),
        .Solicitar_Tarjeta(Solicitar_Tarjeta),
        .sf0_1(sf0_1),
        .sf1_1(sf1_1)
    );
    task testcase001;

    begin
        test_num = 1;

        s1_1 = 0; s0_1 = 0;
        A1 = 0; A2 = 0; A3 = 0; A4 = 0;
        B1 = 0; B2 = 0; B3 = 0; B4 = 0;
        ATRAS = 0; ACCESO_2 = 0;

        #1;


        check_outputs(0, 0, 1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        s1_1 = 0; s0_1 = 0;
        A1 = 1; A2 = 0; A3 = 0; A4 = 0;
        B1 = 0; B2 = 0; B3 = 0; B4 = 0;
        ATRAS = 0; ACCESO_2 = 0;

        #1;


        check_outputs(0, 0, 1, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        s1_1 = 0; s0_1 = 1;
        A1 = 0; A2 = 0; A3 = 0; A4 = 0;
        B1 = 0; B2 = 0; B3 = 0; B4 = 0;
        ATRAS = 0; ACCESO_2 = 0;

        #1;


        check_outputs(0, 1, 0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        s1_1 = 0; s0_1 = 1;
        A1 = 0; A2 = 0; A3 = 0; A4 = 0;
        B1 = 1; B2 = 0; B3 = 0; B4 = 0;
        ATRAS = 0; ACCESO_2 = 0;

        #1;


        check_outputs(0, 1, 0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        s1_1 = 0; s0_1 = 1;
        A1 = 0; A2 = 0; A3 = 0; A4 = 0;
        B1 = 0; B2 = 0; B3 = 0; B4 = 0;
        ATRAS = 1; ACCESO_2 = 0;

        #1;


        check_outputs(0, 1, 0, 0, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        s1_1 = 1; s0_1 = 0;
        A1 = 0; A2 = 0; A3 = 0; A4 = 0;
        B1 = 0; B2 = 0; B3 = 0; B4 = 0;
        ATRAS = 0; ACCESO_2 = 1;

        #1;


        check_outputs(1, 0, 0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;

        s1_1 = 1; s0_1 = 0;
        A1 = 0; A2 = 0; A3 = 0; A4 = 0;
        B1 = 0; B2 = 0; B3 = 0; B4 = 0;
        ATRAS = 1; ACCESO_2 = 0;

        #1;


        check_outputs(0, 0, 0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;

        s1_1 = 0; s0_1 = 0;
        A1 = 1; A2 = 1; A3 = 1; A4 = 1;
        B1 = 0; B2 = 0; B3 = 0; B4 = 0;
        ATRAS = 0; ACCESO_2 = 0;

        #1;


        check_outputs(0, 0, 1, 1, 0);
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
        input expected_ACCESO_1;
        input expected_Solicitar_Pin;
        input expected_Solicitar_Tarjeta;
        input expected_sf0_1;
        input expected_sf1_1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ACCESO_1 === (expected_ACCESO_1 ^ ACCESO_1 ^ expected_ACCESO_1) &&
                expected_Solicitar_Pin === (expected_Solicitar_Pin ^ Solicitar_Pin ^ expected_Solicitar_Pin) &&
                expected_Solicitar_Tarjeta === (expected_Solicitar_Tarjeta ^ Solicitar_Tarjeta ^ expected_Solicitar_Tarjeta) &&
                expected_sf0_1 === (expected_sf0_1 ^ sf0_1 ^ expected_sf0_1) &&
                expected_sf1_1 === (expected_sf1_1 ^ sf1_1 ^ expected_sf1_1)) begin
                $display("PASS");
                $display("  Outputs: ACCESO_1=%b, Solicitar_Pin=%b, Solicitar_Tarjeta=%b, sf0_1=%b, sf1_1=%b",
                         ACCESO_1, Solicitar_Pin, Solicitar_Tarjeta, sf0_1, sf1_1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ACCESO_1=%b, Solicitar_Pin=%b, Solicitar_Tarjeta=%b, sf0_1=%b, sf1_1=%b",
                         expected_ACCESO_1, expected_Solicitar_Pin, expected_Solicitar_Tarjeta, expected_sf0_1, expected_sf1_1);
                $display("  Got:      ACCESO_1=%b, Solicitar_Pin=%b, Solicitar_Tarjeta=%b, sf0_1=%b, sf1_1=%b",
                         ACCESO_1, Solicitar_Pin, Solicitar_Tarjeta, sf0_1, sf1_1);
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
