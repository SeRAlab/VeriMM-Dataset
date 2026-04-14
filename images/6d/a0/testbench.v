`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg avmm_atpgmode;
    reg [5:0] avmm_dprio_address;
    reg [1:0] avmm_dprio_byteen;
    reg avmm_dprio_read;
    reg avmm_dprio_write;
    reg [15:0] avmm_dprio_writedata;
    reg avmm_mdio_dis;
    reg avmm_scanen;
    reg avmm_ser_shift_load;
    reg dprio_init_done;
    reg init_atpgmode;
    reg [5:0] init_dprio_address;
    reg [1:0] init_dprio_byteen;
    reg init_dprio_read;
    reg init_dprio_write;
    reg [15:0] init_dprio_writedata;
    reg init_mdio_dis;
    reg init_scanen;
    reg init_ser_shift_load;
    wire atpgmode;
    wire [5:0] dprio_address;
    wire [1:0] dprio_byteen;
    wire dprio_read;
    wire dprio_write;
    wire [15:0] dprio_writedata;
    wire mdio_dis;
    wire scanen;
    wire ser_shift_load;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .avmm_atpgmode(avmm_atpgmode),
        .avmm_dprio_address(avmm_dprio_address),
        .avmm_dprio_byteen(avmm_dprio_byteen),
        .avmm_dprio_read(avmm_dprio_read),
        .avmm_dprio_write(avmm_dprio_write),
        .avmm_dprio_writedata(avmm_dprio_writedata),
        .avmm_mdio_dis(avmm_mdio_dis),
        .avmm_scanen(avmm_scanen),
        .avmm_ser_shift_load(avmm_ser_shift_load),
        .dprio_init_done(dprio_init_done),
        .init_atpgmode(init_atpgmode),
        .init_dprio_address(init_dprio_address),
        .init_dprio_byteen(init_dprio_byteen),
        .init_dprio_read(init_dprio_read),
        .init_dprio_write(init_dprio_write),
        .init_dprio_writedata(init_dprio_writedata),
        .init_mdio_dis(init_mdio_dis),
        .init_scanen(init_scanen),
        .init_ser_shift_load(init_ser_shift_load),
        .atpgmode(atpgmode),
        .dprio_address(dprio_address),
        .dprio_byteen(dprio_byteen),
        .dprio_read(dprio_read),
        .dprio_write(dprio_write),
        .dprio_writedata(dprio_writedata),
        .mdio_dis(mdio_dis),
        .scanen(scanen),
        .ser_shift_load(ser_shift_load)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initialization Mode (dprio_init_done = 0)", test_num);


            dprio_init_done = 1'b0;


            init_dprio_address   = 6'h2A;
            init_dprio_read      = 1'b1;
            init_dprio_byteen    = 2'b11;
            init_dprio_write     = 1'b0;
            init_dprio_writedata = 16'hABCD;
            init_atpgmode        = 1'b1;
            init_mdio_dis        = 1'b0;
            init_scanen          = 1'b1;
            init_ser_shift_load  = 1'b0;


            avmm_dprio_address   = 6'h05;
            avmm_dprio_read      = 1'b0;
            avmm_dprio_byteen    = 2'b00;
            avmm_dprio_write     = 1'b1;
            avmm_dprio_writedata = 16'h5555;
            avmm_atpgmode        = 1'b0;
            avmm_mdio_dis        = 1'b1;
            avmm_scanen          = 1'b0;
            avmm_ser_shift_load  = 1'b1;


            #1;



            check_outputs(
                1'b1,
                6'h2A,
                2'b11,
                1'b1,
                1'b0,
                16'hABCD,
                1'b0,
                1'b1,
                1'b0
            );
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Operational Mode (dprio_init_done = 1)", test_num);


            dprio_init_done = 1'b1;


            init_dprio_address   = 6'h00;
            init_dprio_read      = 1'b0;
            init_dprio_byteen    = 2'b00;
            init_dprio_write     = 1'b0;
            init_dprio_writedata = 16'h0000;
            init_atpgmode        = 1'b0;
            init_mdio_dis        = 1'b1;
            init_scanen          = 1'b0;
            init_ser_shift_load  = 1'b1;


            avmm_dprio_address   = 6'h1F;
            avmm_dprio_read      = 1'b1;
            avmm_dprio_byteen    = 2'b10;
            avmm_dprio_write     = 1'b1;
            avmm_dprio_writedata = 16'hDEAD;
            avmm_atpgmode        = 1'b1;
            avmm_mdio_dis        = 1'b0;
            avmm_scanen          = 1'b1;
            avmm_ser_shift_load  = 1'b0;


            #1;



            check_outputs(
                1'b0,
                6'h1F,
                2'b10,
                1'b1,
                1'b1,
                16'hDEAD,
                1'b1,
                1'b0,
                1'b1
            );
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Verify Passthrough Independence", test_num);


            dprio_init_done = 1'b1;


            avmm_dprio_address   = 6'h3F;
            avmm_dprio_read      = 1'b1;
            avmm_dprio_byteen    = 2'b01;
            avmm_dprio_write     = 1'b0;
            avmm_dprio_writedata = 16'hFFFF;


            init_atpgmode        = 1'b1;
            init_mdio_dis        = 1'b1;
            init_scanen          = 1'b1;
            init_ser_shift_load  = 1'b1;


            #1;



            check_outputs(1'b1, 6'h3F, 2'b01, 1'b1, 1'b0, 16'hFFFF, 1'b1, 1'b1, 1'b1);


            init_atpgmode        = 1'b0;
            init_mdio_dis        = 1'b0;
            init_scanen          = 1'b0;
            init_ser_shift_load  = 1'b0;


            #1;



            check_outputs(1'b0, 6'h3F, 2'b01, 1'b1, 1'b0, 16'hFFFF, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: All Zeros and All Ones", test_num);


            dprio_init_done = 1'b0;
            init_dprio_address   = 6'h00;
            init_dprio_read      = 1'b0;
            init_dprio_byteen    = 2'b00;
            init_dprio_write     = 1'b0;
            init_dprio_writedata = 16'h0000;
            init_atpgmode        = 1'b0;
            init_mdio_dis        = 1'b0;
            init_scanen          = 1'b0;
            init_ser_shift_load  = 1'b0;

            #1;


            check_outputs(1'b0, 6'h00, 2'b00, 1'b0, 1'b0, 16'h0000, 1'b0, 1'b0, 1'b0);


            dprio_init_done = 1'b1;
            avmm_dprio_address   = 6'h3F;
            avmm_dprio_read      = 1'b1;
            avmm_dprio_byteen    = 2'b11;
            avmm_dprio_write     = 1'b1;
            avmm_dprio_writedata = 16'hFFFF;


            #1;



            check_outputs(1'b0, 6'h3F, 2'b11, 1'b1, 1'b1, 16'hFFFF, 1'b0, 1'b0, 1'b0);
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
        input expected_atpgmode;
        input [5:0] expected_dprio_address;
        input [1:0] expected_dprio_byteen;
        input expected_dprio_read;
        input expected_dprio_write;
        input [15:0] expected_dprio_writedata;
        input expected_mdio_dis;
        input expected_scanen;
        input expected_ser_shift_load;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_atpgmode === (expected_atpgmode ^ atpgmode ^ expected_atpgmode) &&
                expected_dprio_address === (expected_dprio_address ^ dprio_address ^ expected_dprio_address) &&
                expected_dprio_byteen === (expected_dprio_byteen ^ dprio_byteen ^ expected_dprio_byteen) &&
                expected_dprio_read === (expected_dprio_read ^ dprio_read ^ expected_dprio_read) &&
                expected_dprio_write === (expected_dprio_write ^ dprio_write ^ expected_dprio_write) &&
                expected_dprio_writedata === (expected_dprio_writedata ^ dprio_writedata ^ expected_dprio_writedata) &&
                expected_mdio_dis === (expected_mdio_dis ^ mdio_dis ^ expected_mdio_dis) &&
                expected_scanen === (expected_scanen ^ scanen ^ expected_scanen) &&
                expected_ser_shift_load === (expected_ser_shift_load ^ ser_shift_load ^ expected_ser_shift_load)) begin
                $display("PASS");
                $display("  Outputs: atpgmode=%b, dprio_address=%h, dprio_byteen=%h, dprio_read=%b, dprio_write=%b, dprio_writedata=%h, mdio_dis=%b, scanen=%b, ser_shift_load=%b",
                         atpgmode, dprio_address, dprio_byteen, dprio_read, dprio_write, dprio_writedata, mdio_dis, scanen, ser_shift_load);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: atpgmode=%b, dprio_address=%h, dprio_byteen=%h, dprio_read=%b, dprio_write=%b, dprio_writedata=%h, mdio_dis=%b, scanen=%b, ser_shift_load=%b",
                         expected_atpgmode, expected_dprio_address, expected_dprio_byteen, expected_dprio_read, expected_dprio_write, expected_dprio_writedata, expected_mdio_dis, expected_scanen, expected_ser_shift_load);
                $display("  Got:      atpgmode=%b, dprio_address=%h, dprio_byteen=%h, dprio_read=%b, dprio_write=%b, dprio_writedata=%h, mdio_dis=%b, scanen=%b, ser_shift_load=%b",
                         atpgmode, dprio_address, dprio_byteen, dprio_read, dprio_write, dprio_writedata, mdio_dis, scanen, ser_shift_load);
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
