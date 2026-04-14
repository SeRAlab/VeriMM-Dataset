`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    reg reset;
    reg wenb;
    wire [7:0] reg_0x66;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .reset(reset),
        .wenb(wenb),
        .reg_0x66(reg_0x66)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            wenb = 1;
            in_data = 8'h00;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Writing 8'hAA with wenb=0", test_num);
            reset_dut();

            in_data = 8'hAA;
            wenb = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying Write Disable (wenb=1)", test_num);
            reset_dut();


            in_data = 8'h55;
            wenb = 0;
            @(posedge clk);
            #2;


            in_data = 8'hFF;
            wenb = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Performing successive writes", test_num);
            reset_dut();


            in_data = 8'h12;
            wenb = 0;
            @(posedge clk);
            #2;


            in_data = 8'h34;
            wenb = 0;
            @(posedge clk);
            #2;


            in_data = 8'h56;
            wenb = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h56);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Data stability when wenb=1", test_num);
            reset_dut();


            in_data = 8'hCC;
            wenb = 0;
            @(posedge clk);
            #2;


            wenb = 1;
            in_data = 8'h00; @(posedge clk); #2;
            in_data = 8'hFF; @(posedge clk); #2;
            in_data = 8'h77; @(posedge clk); #2;

            #1;


            check_outputs(8'hCC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset override during write attempt", test_num);
            reset_dut();


            in_data = 8'h99;
            wenb = 0;
            reset = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h00);
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
        input [7:0] expected_reg_0x66;
        begin
            if (expected_reg_0x66 === (expected_reg_0x66 ^ reg_0x66 ^ expected_reg_0x66)) begin
                $display("PASS");
                $display("  Outputs: reg_0x66=%h",
                         reg_0x66);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_0x66=%h",
                         expected_reg_0x66);
                $display("  Got:      reg_0x66=%h",
                         reg_0x66);
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
        $dumpvars(0,clk, in_data, reset, wenb, reg_0x66);
    end

endmodule
