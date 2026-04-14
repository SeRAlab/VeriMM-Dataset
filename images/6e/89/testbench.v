`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg MCU_DATA_TO_MEM;
    reg [7:0] MCU_IN_DATA;
    reg MCU_OVR;
    reg MCU_READ;
    reg MCU_WRITE;
    reg MODE;
    reg [7:0] MSU_DATA_OUT;
    reg ROM_ADDR0;
    reg ROM_DATA_TO_MCU_MEM;
    reg ROM_DATA_TO_SNES_MEM;
    reg SNES_DATA_TO_MEM;
    reg SNES_READ;
    reg SNES_WRITE;
    wire [7:0] MCU_OUT_DATA;
    wire [7:0] MSU_DATA_IN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .MCU_DATA_TO_MEM(MCU_DATA_TO_MEM),
        .MCU_IN_DATA(MCU_IN_DATA),
        .MCU_OVR(MCU_OVR),
        .MCU_READ(MCU_READ),
        .MCU_WRITE(MCU_WRITE),
        .MODE(MODE),
        .MSU_DATA_OUT(MSU_DATA_OUT),
        .ROM_ADDR0(ROM_ADDR0),
        .ROM_DATA_TO_MCU_MEM(ROM_DATA_TO_MCU_MEM),
        .ROM_DATA_TO_SNES_MEM(ROM_DATA_TO_SNES_MEM),
        .SNES_DATA_TO_MEM(SNES_DATA_TO_MEM),
        .SNES_READ(SNES_READ),
        .SNES_WRITE(SNES_WRITE),
        .MCU_OUT_DATA(MCU_OUT_DATA),
        .MSU_DATA_IN(MSU_DATA_IN)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            MCU_DATA_TO_MEM = 0;
            MCU_IN_DATA = 8'h00;
            MCU_OVR = 0;
            MCU_READ = 0;
            MCU_WRITE = 0;
            MODE = 0;
            MSU_DATA_OUT = 8'h00;
            ROM_ADDR0 = 0;
            ROM_DATA_TO_MCU_MEM = 0;
            ROM_DATA_TO_SNES_MEM = 0;
            SNES_DATA_TO_MEM = 0;
            SNES_READ = 0;
            SNES_WRITE = 0;
            repeat(2) @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MCU to MSU Write Path", test_num);
            reset_dut();

            MCU_IN_DATA = 8'hA5;
            MCU_WRITE = 1;
            SNES_DATA_TO_MEM = 1;

            repeat(2) @(posedge CLK);


            #1;



            check_outputs(8'h00, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MSU to MCU Read Path", test_num);
            reset_dut();

            MSU_DATA_OUT = 8'h5A;
            MCU_READ = 1;
            ROM_DATA_TO_MCU_MEM = 1;

            repeat(2) @(posedge CLK);


            #1;



            check_outputs(8'h5A, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: ROM to MCU Memory Access", test_num);
            reset_dut();

            ROM_DATA_TO_MCU_MEM = 1;
            MCU_READ = 1;


            repeat(2) @(posedge CLK);



            #1;




            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MCU Override Mode", test_num);
            reset_dut();

            MCU_OVR = 1;
            MODE = 1;
            MCU_IN_DATA = 8'hFF;
            MCU_WRITE = 1;

            repeat(2) @(posedge CLK);


            #1;



            check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: SNES to MSU Path", test_num);
            reset_dut();

            SNES_WRITE = 1;
            SNES_DATA_TO_MEM = 1;


            repeat(2) @(posedge CLK);



            #1;




            check_outputs(8'h00, 8'h00);
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
        input [7:0] expected_MCU_OUT_DATA;
        input [7:0] expected_MSU_DATA_IN;
        begin
            if (expected_MCU_OUT_DATA === (expected_MCU_OUT_DATA ^ MCU_OUT_DATA ^ expected_MCU_OUT_DATA) &&
                expected_MSU_DATA_IN === (expected_MSU_DATA_IN ^ MSU_DATA_IN ^ expected_MSU_DATA_IN)) begin
                $display("PASS");
                $display("  Outputs: MCU_OUT_DATA=%h, MSU_DATA_IN=%h",
                         MCU_OUT_DATA, MSU_DATA_IN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MCU_OUT_DATA=%h, MSU_DATA_IN=%h",
                         expected_MCU_OUT_DATA, expected_MSU_DATA_IN);
                $display("  Got:      MCU_OUT_DATA=%h, MSU_DATA_IN=%h",
                         MCU_OUT_DATA, MSU_DATA_IN);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,CLK, MCU_DATA_TO_MEM, MCU_IN_DATA, MCU_OVR, MCU_READ, MCU_WRITE, MODE, MSU_DATA_OUT, ROM_ADDR0, ROM_DATA_TO_MCU_MEM, ROM_DATA_TO_SNES_MEM, SNES_DATA_TO_MEM, SNES_READ, SNES_WRITE, MCU_OUT_DATA, MSU_DATA_IN);
    end

endmodule
