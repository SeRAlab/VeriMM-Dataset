`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_ena;
    reg [31:0] pbus_in;
    reg rst;
    wire [7:0] busout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_ena(clk_ena),
        .pbus_in(pbus_in),
        .rst(rst),
        .busout(busout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clk_ena = 0;
            pbus_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All segments 0x01", test_num);
            reset_dut();
            pbus_in = 32'h01010101;
            clk_ena = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power of 2 bits (1, 2, 4, 8)", test_num);
            reset_dut();
            pbus_in = 32'h01020408;
            clk_ena = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Clock Enable Low (Data should not update)", test_num);
            reset_dut();
            pbus_in = 32'hFFFFFFFF;
            clk_ena = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Bit Pattern", test_num);
            reset_dut();



            pbus_in = 32'h12345678;
            clk_ena = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Value Retention on Enable Low", test_num);
            reset_dut();


            pbus_in = 32'hFF000000;
            clk_ena = 1;
            @(posedge clk);
            #1;


            pbus_in = 32'h00000000;
            clk_ena = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All segments 0xFF", test_num);
            reset_dut();
            pbus_in = 32'hFFFFFFFF;
            clk_ena = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed constants", test_num);
            reset_dut();
            pbus_in = 32'hA5A5A500;
            clk_ena = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
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
        input [7:0] expected_busout;
        begin
            if (expected_busout === (expected_busout ^ busout ^ expected_busout)) begin
                $display("PASS");
                $display("  Outputs: busout=%h",
                         busout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busout=%h",
                         expected_busout);
                $display("  Got:      busout=%h",
                         busout);
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
        $dumpvars(0,clk, clk_ena, pbus_in, rst, busout);
    end

endmodule
