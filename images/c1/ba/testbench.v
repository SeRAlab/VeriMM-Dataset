`timescale 1ns/1ps

module bus_manager_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] RAM_data;
    reg [7:0] ROM_data_out;
    reg [15:0] addr;
    reg clk50;
    reg clk_per;
    reg [7:0] cpu_data_out;
    reg cpu_rw;
    reg cpu_vma;
    reg [7:0] jt_data_out;
    reg rst50;
    reg [7:0] sound_latch;
    reg [1:0] sw_sel;
    wire RAM_cs;
    wire clear_irq;
    wire [7:0] cpu_data_in;
    wire opm_cs_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bus_manager dut (
        .RAM_data(RAM_data),
        .ROM_data_out(ROM_data_out),
        .addr(addr),
        .clk50(clk50),
        .clk_per(clk_per),
        .cpu_data_out(cpu_data_out),
        .cpu_rw(cpu_rw),
        .cpu_vma(cpu_vma),
        .jt_data_out(jt_data_out),
        .rst50(rst50),
        .sound_latch(sound_latch),
        .sw_sel(sw_sel),
        .RAM_cs(RAM_cs),
        .clear_irq(clear_irq),
        .cpu_data_in(cpu_data_in),
        .opm_cs_n(opm_cs_n)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: System Reset", test_num);
            rst50 = 1;
            addr = 16'h0000;
            cpu_vma = 0;
            cpu_rw = 1;
            RAM_data = 8'h00;
            ROM_data_out = 8'h00;
            jt_data_out = 8'h00;
            sound_latch = 8'h00;
            sw_sel = 2'b00;
            #40;
            rst50 = 0;
            #20;

            #1;


            check_outputs(1'b0, 1'b0, 8'hzz, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: RAM Read Operation", test_num);
            rst50 = 0;
            addr = 16'h1000;
            cpu_vma = 1;
            cpu_rw = 1;
            RAM_data = 8'hA5;
            #20;
            #1;

            check_outputs(1'b1, 1'b0, 8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: ROM Read Operation", test_num);
            rst50 = 0;
            addr = 16'hC000;
            cpu_vma = 1;
            cpu_rw = 1;
            ROM_data_out = 8'h5A;
            #20;
            #1;

            check_outputs(1'b0, 1'b0, 8'h5A, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: OPM Chip Select", test_num);
            rst50 = 0;
            addr = 16'h4000;
            cpu_vma = 1;
            cpu_rw = 0;
            #20;

            #1;


            check_outputs(1'b0, 1'b0, 8'hzz, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: JT Peripheral Read", test_num);
            rst50 = 0;
            addr = 16'h2000;
            cpu_vma = 1;
            cpu_rw = 1;
            jt_data_out = 8'h33;
            #20;
            #1;

            check_outputs(1'b0, 1'b0, 8'h33, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Sound Latch Read", test_num);
            rst50 = 0;
            addr = 16'h5000;
            cpu_vma = 1;
            cpu_rw = 1;
            sound_latch = 8'hCC;
            #20;
            #1;

            check_outputs(1'b0, 1'b0, 8'hCC, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Interrupt Clear Write", test_num);
            rst50 = 0;
            addr = 16'h7000;
            cpu_vma = 1;
            cpu_rw = 0;
            cpu_data_out = 8'h01;
            #20;
            #1;

            check_outputs(1'b0, 1'b1, 8'hzz, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Inactive VMA (High Impedance)", test_num);
            rst50 = 0;
            addr = 16'h1000;
            cpu_vma = 0;
            cpu_rw = 1;
            #20;

            #1;


            check_outputs(1'b0, 1'b0, 8'hzz, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bus_manager Testbench");
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
        input expected_RAM_cs;
        input expected_clear_irq;
        input [7:0] expected_cpu_data_in;
        input expected_opm_cs_n;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RAM_cs === (expected_RAM_cs ^ RAM_cs ^ expected_RAM_cs) &&
                expected_clear_irq === (expected_clear_irq ^ clear_irq ^ expected_clear_irq) &&
                expected_cpu_data_in === (expected_cpu_data_in ^ cpu_data_in ^ expected_cpu_data_in) &&
                expected_opm_cs_n === (expected_opm_cs_n ^ opm_cs_n ^ expected_opm_cs_n)) begin
                $display("PASS");
                $display("  Outputs: RAM_cs=%b, clear_irq=%b, cpu_data_in=%h, opm_cs_n=%b",
                         RAM_cs, clear_irq, cpu_data_in, opm_cs_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RAM_cs=%b, clear_irq=%b, cpu_data_in=%h, opm_cs_n=%b",
                         expected_RAM_cs, expected_clear_irq, expected_cpu_data_in, expected_opm_cs_n);
                $display("  Got:      RAM_cs=%b, clear_irq=%b, cpu_data_in=%h, opm_cs_n=%b",
                         RAM_cs, clear_irq, cpu_data_in, opm_cs_n);
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
