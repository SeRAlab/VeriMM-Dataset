`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ep85b3b;
    reg fnd82ee;
    reg nt2d9dd;
    reg ph9b05d;
    reg rst_n;
    reg sys_clk;
    reg [15:0] ux36419;
    reg [11:0] yz3360b;
    wire ayfa306;
    wire cm77093;
    wire [11:0] eac1777;
    wire fn5f460;
    wire gdaecfa;
    wire hoeee12;
    wire hqbbb8;
    wire [22:0] ie872fa;
    wire jc5ddc2;
    wire qgcbe8c;
    wire [1:0] rxdp_dllp_val;
    wire [2:0] rxdp_pmd_type;
    wire [23:0] rxdp_vsd_data;
    wire [1:0] sj397d1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ep85b3b(ep85b3b),
        .fnd82ee(fnd82ee),
        .nt2d9dd(nt2d9dd),
        .ph9b05d(ph9b05d),
        .rst_n(rst_n),
        .sys_clk(sys_clk),
        .ux36419(ux36419),
        .yz3360b(yz3360b),
        .ayfa306(ayfa306),
        .cm77093(cm77093),
        .eac1777(eac1777),
        .fn5f460(fn5f460),
        .gdaecfa(gdaecfa),
        .hoeee12(hoeee12),
        .hqbbb8(hqbbb8),
        .ie872fa(ie872fa),
        .jc5ddc2(jc5ddc2),
        .qgcbe8c(qgcbe8c),
        .rxdp_dllp_val(rxdp_dllp_val),
        .rxdp_pmd_type(rxdp_pmd_type),
        .rxdp_vsd_data(rxdp_vsd_data),
        .sj397d1(sj397d1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset and Initial State", test_num);


            rst_n = 0;
            sys_clk = 0;
            ux36419 = 16'h0000;
            yz3360b = 12'h000;
            ep85b3b = 0;
            nt2d9dd = 0;
            ph9b05d = 0;
            fnd82ee = 0;

            #100;
            rst_n = 1;
            #100;



            #1;




            check_outputs(1'b0, 1'b0, 12'h000, 1'b0, 1'b0, 1'b0, 1'b0, 23'h000000, 1'b0, 1'b0, 2'b00, 3'b000, 24'h000000, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Data Input Pattern", test_num);

            rst_n = 0; #20; rst_n = 1; #20;

            ux36419 = 16'hFFFF;
            yz3360b = 12'hFFF;
            ep85b3b = 1;
            nt2d9dd = 1;
            ph9b05d = 1;
            fnd82ee = 1;

            #100;


            #1;



            check_outputs(1'b1, 1'b1, 12'hFFF, 1'b1, 1'b1, 1'b1, 1'b1, 23'h7FFFFF, 1'b1, 1'b1, 2'b11, 3'b111, 24'hFFFFFF, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bit Pattern", test_num);

            rst_n = 0; #20; rst_n = 1; #20;

            ux36419 = 16'hAAAA;
            yz3360b = 12'h555;
            ep85b3b = 1;
            nt2d9dd = 0;
            ph9b05d = 1;
            fnd82ee = 0;

            #100;


            #1;



            check_outputs(1'b0, 1'b1, 12'h555, 1'b1, 1'b0, 1'b1, 1'b0, 23'h2AAAAA, 1'b1, 1'b0, 2'b10, 3'b101, 24'hAA5555, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control Signal Toggle", test_num);

            rst_n = 0; #20; rst_n = 1; #20;

            ux36419 = 16'h1234;
            yz3360b = 12'hABC;


            ep85b3b = 0; nt2d9dd = 1; ph9b05d = 0; fnd82ee = 1;
            #50;

            #1;


            check_outputs(1'b1, 1'b0, 12'hABC, 1'b0, 1'b1, 1'b0, 1'b1, 23'h012345, 1'b0, 1'b1, 2'b01, 3'b010, 24'h123ABC, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Data Values", test_num);

            rst_n = 0; #20; rst_n = 1; #20;

            ux36419 = 16'h8001;
            yz3360b = 12'h001;
            ep85b3b = 1;
            nt2d9dd = 1;
            ph9b05d = 0;
            fnd82ee = 0;

            #100;

            #1;


            check_outputs(1'b0, 1'b0, 12'h001, 1'b1, 1'b0, 1'b1, 1'b0, 23'h400001, 1'b1, 1'b1, 2'b11, 3'b001, 24'h800101, 2'b11);
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
        input expected_ayfa306;
        input expected_cm77093;
        input [11:0] expected_eac1777;
        input expected_fn5f460;
        input expected_gdaecfa;
        input expected_hoeee12;
        input expected_hqbbb8;
        input [22:0] expected_ie872fa;
        input expected_jc5ddc2;
        input expected_qgcbe8c;
        input [1:0] expected_rxdp_dllp_val;
        input [2:0] expected_rxdp_pmd_type;
        input [23:0] expected_rxdp_vsd_data;
        input [1:0] expected_sj397d1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ayfa306 === (expected_ayfa306 ^ ayfa306 ^ expected_ayfa306) &&
                expected_cm77093 === (expected_cm77093 ^ cm77093 ^ expected_cm77093) &&
                expected_eac1777 === (expected_eac1777 ^ eac1777 ^ expected_eac1777) &&
                expected_fn5f460 === (expected_fn5f460 ^ fn5f460 ^ expected_fn5f460) &&
                expected_gdaecfa === (expected_gdaecfa ^ gdaecfa ^ expected_gdaecfa) &&
                expected_hoeee12 === (expected_hoeee12 ^ hoeee12 ^ expected_hoeee12) &&
                expected_hqbbb8 === (expected_hqbbb8 ^ hqbbb8 ^ expected_hqbbb8) &&
                expected_ie872fa === (expected_ie872fa ^ ie872fa ^ expected_ie872fa) &&
                expected_jc5ddc2 === (expected_jc5ddc2 ^ jc5ddc2 ^ expected_jc5ddc2) &&
                expected_qgcbe8c === (expected_qgcbe8c ^ qgcbe8c ^ expected_qgcbe8c) &&
                expected_rxdp_dllp_val === (expected_rxdp_dllp_val ^ rxdp_dllp_val ^ expected_rxdp_dllp_val) &&
                expected_rxdp_pmd_type === (expected_rxdp_pmd_type ^ rxdp_pmd_type ^ expected_rxdp_pmd_type) &&
                expected_rxdp_vsd_data === (expected_rxdp_vsd_data ^ rxdp_vsd_data ^ expected_rxdp_vsd_data) &&
                expected_sj397d1 === (expected_sj397d1 ^ sj397d1 ^ expected_sj397d1)) begin
                $display("PASS");
                $display("  Outputs: ayfa306=%b, cm77093=%b, eac1777=%h, fn5f460=%b, gdaecfa=%b, hoeee12=%b, hqbbb8=%b, ie872fa=%h, jc5ddc2=%b, qgcbe8c=%b, rxdp_dllp_val=%h, rxdp_pmd_type=%h, rxdp_vsd_data=%h, sj397d1=%h",
                         ayfa306, cm77093, eac1777, fn5f460, gdaecfa, hoeee12, hqbbb8, ie872fa, jc5ddc2, qgcbe8c, rxdp_dllp_val, rxdp_pmd_type, rxdp_vsd_data, sj397d1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ayfa306=%b, cm77093=%b, eac1777=%h, fn5f460=%b, gdaecfa=%b, hoeee12=%b, hqbbb8=%b, ie872fa=%h, jc5ddc2=%b, qgcbe8c=%b, rxdp_dllp_val=%h, rxdp_pmd_type=%h, rxdp_vsd_data=%h, sj397d1=%h",
                         expected_ayfa306, expected_cm77093, expected_eac1777, expected_fn5f460, expected_gdaecfa, expected_hoeee12, expected_hqbbb8, expected_ie872fa, expected_jc5ddc2, expected_qgcbe8c, expected_rxdp_dllp_val, expected_rxdp_pmd_type, expected_rxdp_vsd_data, expected_sj397d1);
                $display("  Got:      ayfa306=%b, cm77093=%b, eac1777=%h, fn5f460=%b, gdaecfa=%b, hoeee12=%b, hqbbb8=%b, ie872fa=%h, jc5ddc2=%b, qgcbe8c=%b, rxdp_dllp_val=%h, rxdp_pmd_type=%h, rxdp_vsd_data=%h, sj397d1=%h",
                         ayfa306, cm77093, eac1777, fn5f460, gdaecfa, hoeee12, hqbbb8, ie872fa, jc5ddc2, qgcbe8c, rxdp_dllp_val, rxdp_pmd_type, rxdp_vsd_data, sj397d1);
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
