`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg asic_oe_n;
    reg [15:0] cpuaddr;
    reg [7:0] data_from_asic;
    reg [7:0] data_from_ram;
    reg [7:0] data_from_rom;
    reg ram_oe_n;
    reg rom_oe_n;
    wire [7:0] data_to_cpu;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .asic_oe_n(asic_oe_n),
        .cpuaddr(cpuaddr),
        .data_from_asic(data_from_asic),
        .data_from_ram(data_from_ram),
        .data_from_rom(data_from_rom),
        .ram_oe_n(ram_oe_n),
        .rom_oe_n(rom_oe_n),
        .data_to_cpu(data_to_cpu)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: ROM Active (rom_oe_n=0)", test_num);
        rom_oe_n = 1'b0;
        ram_oe_n = 1'b1;
        asic_oe_n = 1'b1;
        data_from_rom  = 8'hA5;
        data_from_ram  = 8'h00;
        data_from_asic = 8'h00;
        cpuaddr = 16'h1234;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: RAM Active (ram_oe_n=0)", test_num);
        rom_oe_n = 1'b1;
        ram_oe_n = 1'b0;
        asic_oe_n = 1'b1;
        data_from_rom  = 8'h00;
        data_from_ram  = 8'h5A;
        data_from_asic = 8'h00;
        cpuaddr = 16'hABCD;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: ASIC Active (asic_oe_n=0)", test_num);
        rom_oe_n = 1'b1;
        ram_oe_n = 1'b1;
        asic_oe_n = 1'b0;
        data_from_rom  = 8'h00;
        data_from_ram  = 8'h00;
        data_from_asic = 8'h3C;
        cpuaddr = 16'hFFFF;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Default Output (All Enable High)", test_num);
        rom_oe_n = 1'b1;
        ram_oe_n = 1'b1;
        asic_oe_n = 1'b1;
        data_from_rom  = 8'h11;
        data_from_ram  = 8'h22;
        data_from_asic = 8'h33;
        cpuaddr = 16'h0000;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: ROM Active with different data", test_num);
        rom_oe_n = 1'b0;
        ram_oe_n = 1'b1;
        asic_oe_n = 1'b1;
        data_from_rom  = 8'hDE;
        data_from_ram  = 8'hAD;
        data_from_asic = 8'hBE;
        cpuaddr = 16'h8000;
        #1;

        check_outputs(8'hDE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Multiple Enables (Priority Check: ROM > RAM)", test_num);

        rom_oe_n = 1'b0;
        ram_oe_n = 1'b0;
        asic_oe_n = 1'b1;
        data_from_rom  = 8'h10;
        data_from_ram  = 8'h20;
        data_from_asic = 8'h30;
        cpuaddr = 16'h4444;
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Multiple Enables (Priority Check: RAM > ASIC)", test_num);
        rom_oe_n = 1'b1;
        ram_oe_n = 1'b0;
        asic_oe_n = 1'b0;
        data_from_rom  = 8'h11;
        data_from_ram  = 8'h22;
        data_from_asic = 8'h33;
        cpuaddr = 16'h5555;
        #1;

        check_outputs(8'h22);
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
        input [7:0] expected_data_to_cpu;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_to_cpu === (expected_data_to_cpu ^ data_to_cpu ^ expected_data_to_cpu)) begin
                $display("PASS");
                $display("  Outputs: data_to_cpu=%h",
                         data_to_cpu);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_to_cpu=%h",
                         expected_data_to_cpu);
                $display("  Got:      data_to_cpu=%h",
                         data_to_cpu);
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
