`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a14;
    reg a15;
    reg mode_norom;
    reg [7:0] mode_pg0;
    reg [7:0] mode_pg1;
    reg [7:0] mode_pg2;
    reg [7:0] mode_pg3;
    reg mode_ramro;
    reg mreq_n;
    reg rd_n;
    reg wr_n;
    wire mema14;
    wire mema15;
    wire mema16;
    wire mema17;
    wire mema18;
    wire mema21;
    wire memoe_n;
    wire memwe_n;
    wire ram0cs_n;
    wire ram1cs_n;
    wire ram2cs_n;
    wire ram3cs_n;
    wire romcs_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a14(a14),
        .a15(a15),
        .mode_norom(mode_norom),
        .mode_pg0(mode_pg0),
        .mode_pg1(mode_pg1),
        .mode_pg2(mode_pg2),
        .mode_pg3(mode_pg3),
        .mode_ramro(mode_ramro),
        .mreq_n(mreq_n),
        .rd_n(rd_n),
        .wr_n(wr_n),
        .mema14(mema14),
        .mema15(mema15),
        .mema16(mema16),
        .mema17(mema17),
        .mema18(mema18),
        .mema21(mema21),
        .memoe_n(memoe_n),
        .memwe_n(memwe_n),
        .ram0cs_n(ram0cs_n),
        .ram1cs_n(ram1cs_n),
        .ram2cs_n(ram2cs_n),
        .ram3cs_n(ram3cs_n),
        .romcs_n(romcs_n)
    );
    task testcase001;

    begin
        test_num = 1;
        a15 = 0; a14 = 0;
        mreq_n = 1; rd_n = 1; wr_n = 1;
        mode_norom = 0; mode_ramro = 0;
        mode_pg0 = 8'h00; mode_pg1 = 8'h00; mode_pg2 = 8'h00; mode_pg3 = 8'h00;


        #1;



        check_outputs(0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a15 = 0; a14 = 0;
        mreq_n = 0; rd_n = 0; wr_n = 1;
        mode_norom = 0; mode_ramro = 0;
        mode_pg0 = 8'h81;


        #1;



        check_outputs(1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a15 = 0; a14 = 0;
        mreq_n = 0; rd_n = 0; wr_n = 1;
        mode_norom = 1; mode_ramro = 0;
        mode_pg0 = 8'h12;


        #1;



        check_outputs(0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a15 = 0; a14 = 1;
        mreq_n = 0; rd_n = 1; wr_n = 0;
        mode_ramro = 0;
        mode_pg1 = 8'h0F;


        #1;



        check_outputs(1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a15 = 1; a14 = 0;
        mreq_n = 0; rd_n = 0; wr_n = 1;
        mode_pg2 = 8'h90;


        #1;



        check_outputs(0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a15 = 1; a14 = 1;
        mreq_n = 0; rd_n = 1; wr_n = 0;
        mode_ramro = 0;
        mode_pg3 = 8'h24;


        #1;



        check_outputs(0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a15 = 0; a14 = 1;
        mreq_n = 0; rd_n = 1; wr_n = 0;
        mode_ramro = 1;
        mode_pg1 = 8'hAA;


        #1;



        check_outputs(0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a15 = 0; a14 = 0;
        mreq_n = 0; rd_n = 1; wr_n = 0;
        mode_norom = 0;
        mode_pg0 = 8'hFF;




        #1;





        check_outputs(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0);
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
        input expected_mema14;
        input expected_mema15;
        input expected_mema16;
        input expected_mema17;
        input expected_mema18;
        input expected_mema21;
        input expected_memoe_n;
        input expected_memwe_n;
        input expected_ram0cs_n;
        input expected_ram1cs_n;
        input expected_ram2cs_n;
        input expected_ram3cs_n;
        input expected_romcs_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mema14 === (expected_mema14 ^ mema14 ^ expected_mema14) &&
                expected_mema15 === (expected_mema15 ^ mema15 ^ expected_mema15) &&
                expected_mema16 === (expected_mema16 ^ mema16 ^ expected_mema16) &&
                expected_mema17 === (expected_mema17 ^ mema17 ^ expected_mema17) &&
                expected_mema18 === (expected_mema18 ^ mema18 ^ expected_mema18) &&
                expected_mema21 === (expected_mema21 ^ mema21 ^ expected_mema21) &&
                expected_memoe_n === (expected_memoe_n ^ memoe_n ^ expected_memoe_n) &&
                expected_memwe_n === (expected_memwe_n ^ memwe_n ^ expected_memwe_n) &&
                expected_ram0cs_n === (expected_ram0cs_n ^ ram0cs_n ^ expected_ram0cs_n) &&
                expected_ram1cs_n === (expected_ram1cs_n ^ ram1cs_n ^ expected_ram1cs_n) &&
                expected_ram2cs_n === (expected_ram2cs_n ^ ram2cs_n ^ expected_ram2cs_n) &&
                expected_ram3cs_n === (expected_ram3cs_n ^ ram3cs_n ^ expected_ram3cs_n) &&
                expected_romcs_n === (expected_romcs_n ^ romcs_n ^ expected_romcs_n)) begin
                $display("PASS");
                $display("  Outputs: mema14=%b, mema15=%b, mema16=%b, mema17=%b, mema18=%b, mema21=%b, memoe_n=%b, memwe_n=%b, ram0cs_n=%b, ram1cs_n=%b, ram2cs_n=%b, ram3cs_n=%b, romcs_n=%b",
                         mema14, mema15, mema16, mema17, mema18, mema21, memoe_n, memwe_n, ram0cs_n, ram1cs_n, ram2cs_n, ram3cs_n, romcs_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mema14=%b, mema15=%b, mema16=%b, mema17=%b, mema18=%b, mema21=%b, memoe_n=%b, memwe_n=%b, ram0cs_n=%b, ram1cs_n=%b, ram2cs_n=%b, ram3cs_n=%b, romcs_n=%b",
                         expected_mema14, expected_mema15, expected_mema16, expected_mema17, expected_mema18, expected_mema21, expected_memoe_n, expected_memwe_n, expected_ram0cs_n, expected_ram1cs_n, expected_ram2cs_n, expected_ram3cs_n, expected_romcs_n);
                $display("  Got:      mema14=%b, mema15=%b, mema16=%b, mema17=%b, mema18=%b, mema21=%b, memoe_n=%b, memwe_n=%b, ram0cs_n=%b, ram1cs_n=%b, ram2cs_n=%b, ram3cs_n=%b, romcs_n=%b",
                         mema14, mema15, mema16, mema17, mema18, mema21, memoe_n, memwe_n, ram0cs_n, ram1cs_n, ram2cs_n, ram3cs_n, romcs_n);
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
