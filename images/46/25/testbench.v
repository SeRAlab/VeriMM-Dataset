`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg eclk;
    reg reset;
    reg tcr;
    reg thi;
    reg tlo;
    reg wr;
    wire [7:0] data_out;
    wire irq;
    wire spmode;
    wire tmra_ovf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .eclk(eclk),
        .reset(reset),
        .tcr(tcr),
        .thi(thi),
        .tlo(tlo),
        .wr(wr),
        .data_out(data_out),
        .irq(irq),
        .spmode(spmode),
        .tmra_ovf(tmra_ovf)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            wr = 0;
            tlo = 0;
            thi = 0;
            tcr = 0;
            data_in = 8'h00;
            eclk = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Verifying Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Timer Low (tlo) Write/Read", test_num);
            reset_dut();


            @(posedge clk);
            wr = 1; tlo = 1; data_in = 8'h55;
            @(posedge clk);
            wr = 0; tlo = 0;


            @(posedge clk);
            tlo = 1;
            #2;
            #1;

            check_outputs(8'h55, 0, 0, 0);
            tlo = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Timer High (thi) Write/Read", test_num);
            reset_dut();


            @(posedge clk);
            wr = 1; thi = 1; data_in = 8'hAA;
            @(posedge clk);
            wr = 0; thi = 0;


            @(posedge clk);
            thi = 1;
            #2;
            #1;

            check_outputs(8'hAA, 0, 0, 0);
            thi = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: TCR Write and spmode Output", test_num);
            reset_dut();


            @(posedge clk);
            wr = 1; tcr = 1; data_in = 8'h20;
            @(posedge clk);
            wr = 0; tcr = 0;


            @(posedge clk);
            tcr = 1;
            #2;
            #1;

            check_outputs(8'h20, 0, 1, 0);
            tcr = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Timer Overflow/IRQ trigger", test_num);
            reset_dut();


            @(posedge clk);
            wr = 1; tlo = 1; data_in = 8'h02;
            @(posedge clk);

            wr = 1; tlo = 0; thi = 1; data_in = 8'h00;
            @(posedge clk);

            wr = 1; thi = 0; tcr = 1; data_in = 8'h01;
            @(posedge clk);
            wr = 0; tcr = 0;



            repeat(20) @(posedge clk);



            #1;




            check_outputs(8'h00, 1, 0, 1);
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
        input [7:0] expected_data_out;
        input expected_irq;
        input expected_spmode;
        input expected_tmra_ovf;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_irq === (expected_irq ^ irq ^ expected_irq) &&
                expected_spmode === (expected_spmode ^ spmode ^ expected_spmode) &&
                expected_tmra_ovf === (expected_tmra_ovf ^ tmra_ovf ^ expected_tmra_ovf)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, irq=%b, spmode=%b, tmra_ovf=%b",
                         data_out, irq, spmode, tmra_ovf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, irq=%b, spmode=%b, tmra_ovf=%b",
                         expected_data_out, expected_irq, expected_spmode, expected_tmra_ovf);
                $display("  Got:      data_out=%h, irq=%b, spmode=%b, tmra_ovf=%b",
                         data_out, irq, spmode, tmra_ovf);
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
        $dumpvars(0,clk, data_in, eclk, reset, tcr, thi, tlo, wr, data_out, irq, spmode, tmra_ovf);
    end

endmodule
