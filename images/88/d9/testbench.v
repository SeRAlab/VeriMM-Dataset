`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock_i;
    reg [7:0] eram;
    reg [7:0] fdc;
    reg fdc_e;
    reg [7:0] io;
    reg io_e;
    reg [7:0] l_rom;
    reg l_rom_e;
    reg [7:0] pio8255;
    reg pio8255_e;
    reg [7:0] ram;
    reg ram_e;
    reg u_ram_e;
    reg [7:0] u_rom;
    reg u_rom_e;
    wire [7:0] D;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock_i(clock_i),
        .eram(eram),
        .fdc(fdc),
        .fdc_e(fdc_e),
        .io(io),
        .io_e(io_e),
        .l_rom(l_rom),
        .l_rom_e(l_rom_e),
        .pio8255(pio8255),
        .pio8255_e(pio8255_e),
        .ram(ram),
        .ram_e(ram_e),
        .u_ram_e(u_ram_e),
        .u_rom(u_rom),
        .u_rom_e(u_rom_e),
        .D(D)
    );
    task init_signals;

        begin
            l_rom = 8'hA1;
            u_rom = 8'hB2;
            eram = 8'hC3;
            ram = 8'hD4;
            pio8255 = 8'hE5;
            io = 8'hF6;
            fdc = 8'h07;
            l_rom_e = 0;
            u_rom_e = 0;
            u_ram_e = 0;
            ram_e = 0;
            pio8255_e = 0;
            io_e = 0;
            fdc_e = 0;
            clock_i = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: No sources enabled - Expecting 0xFF", test_num);
            init_signals();
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Local ROM enabled", test_num);
            init_signals();
            l_rom_e = 1;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Upper ROM enabled", test_num);
            init_signals();
            u_rom_e = 1;
            #1;

            check_outputs(8'hB2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Upper RAM (eram) enabled", test_num);
            init_signals();
            u_ram_e = 1;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Standard RAM enabled", test_num);
            init_signals();
            ram_e = 1;
            #1;

            check_outputs(8'hD4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: PIO enabled", test_num);
            init_signals();
            pio8255_e = 1;
            #1;

            check_outputs(8'hE5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: I/O enabled", test_num);
            init_signals();
            io_e = 1;
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: FDC enabled", test_num);
            init_signals();
            fdc_e = 1;
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Priority Check - All sources enabled", test_num);
            init_signals();
            l_rom_e = 1; u_rom_e = 1; u_ram_e = 1; ram_e = 1;
            pio8255_e = 1; io_e = 1; fdc_e = 1;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %03d: Priority Check - RAM vs PIO vs FDC", test_num);
            init_signals();
            ram_e = 1; pio8255_e = 1; fdc_e = 1;
            #1;

            check_outputs(8'hD4);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %03d: Priority Check - IO vs FDC", test_num);
            init_signals();
            io_e = 1; fdc_e = 1;
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Testcase %03d: Priority Check - Upper ROM vs Upper RAM", test_num);
            init_signals();
            u_rom_e = 1; u_ram_e = 1;
            #1;

            check_outputs(8'hB2);
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
