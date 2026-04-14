`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] eram;
    reg [7:0] fdc;
    reg fdc_e;
    reg [7:0] io;
    reg io_e;
    reg [7:0] pio8255;
    reg pio8255_e;
    reg [7:0] ram;
    reg ram_e;
    reg u_ram_e;
    wire [7:0] D;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .eram(eram),
        .fdc(fdc),
        .fdc_e(fdc_e),
        .io(io),
        .io_e(io_e),
        .pio8255(pio8255),
        .pio8255_e(pio8255_e),
        .ram(ram),
        .ram_e(ram_e),
        .u_ram_e(u_ram_e),
        .D(D)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        ram_e = 0; u_ram_e = 0; pio8255_e = 0; io_e = 0; fdc_e = 0;
        ram = 8'h11; eram = 8'h22; pio8255 = 8'h33; io = 8'h44; fdc = 8'h55;
        $display("Test %0d: All enables inactive", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        ram_e = 1; u_ram_e = 0; pio8255_e = 0; io_e = 0; fdc_e = 0;
        ram = 8'hA5;
        $display("Test %0d: RAM enabled", test_num);
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        ram_e = 0; u_ram_e = 1; pio8255_e = 0; io_e = 0; fdc_e = 0;
        eram = 8'h5A;
        $display("Test %0d: ERAM enabled", test_num);
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        ram_e = 0; u_ram_e = 0; pio8255_e = 1; io_e = 0; fdc_e = 0;
        pio8255 = 8'h3C;
        $display("Test %0d: PIO8255 enabled", test_num);
        #1;

        check_outputs(8'h3C);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        ram_e = 0; u_ram_e = 0; pio8255_e = 0; io_e = 1; fdc_e = 0;
        io = 8'hC3;
        $display("Test %0d: IO Port enabled", test_num);
        #1;

        check_outputs(8'hC3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        ram_e = 0; u_ram_e = 0; pio8255_e = 0; io_e = 0; fdc_e = 1;
        fdc = 8'h0F;
        $display("Test %0d: FDC enabled", test_num);
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        ram_e = 1; u_ram_e = 0; pio8255_e = 0; io_e = 0; fdc_e = 0;
        ram = 8'h00;
        $display("Test %0d: RAM enabled with 0x00", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        ram_e = 0; u_ram_e = 1; pio8255_e = 0; io_e = 0; fdc_e = 0;
        eram = 8'hFF;
        $display("Test %0d: ERAM enabled with 0xFF", test_num);
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_D;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D === (expected_D ^ D ^ expected_D)) begin
                $display("PASS");
                $display("  Outputs: D=%h",
                         D);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h",
                         expected_D);
                $display("  Got:      D=%h",
                         D);
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
