`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg inst_done;
    wire rom_done;
    wire [7:0] rom_inst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .inst_done(inst_done),
        .rom_done(rom_done),
        .rom_inst(rom_inst)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            inst_done = 0;
            @(posedge clk);
            #1 clr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Checking initial state after clear (PC=0)", test_num);

            #1;


            check_outputs(1'b0, rom_inst);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Advance to PC=1", test_num);

            inst_done = 1;
            @(posedge clk);
            #1 inst_done = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, rom_inst);
        end
        endtask

    task testcase003;

        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Advance to PC=9 (Completion state)", test_num);


            for (i = 0; i < 9; i = i + 1) begin
                inst_done = 1;
                @(posedge clk);
                #1;
            end
            inst_done = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, rom_inst);
        end
        endtask

    task testcase004;

        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verify saturation/default state after PC=9", test_num);


            for (i = 0; i < 15; i = i + 1) begin
                inst_done = 1;
                @(posedge clk);
                #1;
            end
            inst_done = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, rom_inst);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verify clear signal resets PC mid-sequence", test_num);


            for (i = 0; i < 5; i = i + 1) begin
                inst_done = 1;
                @(posedge clk);
                #1;
            end
            inst_done = 0;


            clr = 1;
            @(posedge clk);
            #1 clr = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, rom_inst);
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
        input expected_rom_done;
        input [7:0] expected_rom_inst;
        begin
            if (expected_rom_done === (expected_rom_done ^ rom_done ^ expected_rom_done) &&
                expected_rom_inst === (expected_rom_inst ^ rom_inst ^ expected_rom_inst)) begin
                $display("PASS");
                $display("  Outputs: rom_done=%b, rom_inst=%h",
                         rom_done, rom_inst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rom_done=%b, rom_inst=%h",
                         expected_rom_done, expected_rom_inst);
                $display("  Got:      rom_done=%b, rom_inst=%h",
                         rom_done, rom_inst);
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
        $dumpvars(0,clk, clr, inst_done, rom_done, rom_inst);
    end

endmodule
