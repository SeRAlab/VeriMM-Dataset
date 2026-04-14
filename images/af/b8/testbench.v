`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg clk;
    reg [7:0] idata;
    reg reset;
    reg we_n;
    wire [7:0] odata;
    wire [7:0] opa;
    wire [7:0] opb;
    wire [7:0] opc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .idata(idata),
        .reset(reset),
        .we_n(we_n),
        .odata(odata),
        .opa(opa),
        .opb(opb),
        .opc(opc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            we_n = 1;
            addr = 0;
            idata = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(8'h00, 8'hFF, 8'hFF, 8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            we_n = 0;
            addr = 2'b00;
            idata = 8'hAA;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hAA, 8'hAA, 8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            we_n = 0;
            addr = 2'b01;
            idata = 8'h55;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h55, 8'hFF, 8'h55, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge clk);
            we_n = 0;
            addr = 2'b10;
            idata = 8'h12;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h12, 8'hFF, 8'hFF, 8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(negedge clk);
            we_n = 0; addr = 2'b00; idata = 8'hAA;
            @(posedge clk);

            @(negedge clk);
            we_n = 0; addr = 2'b01; idata = 8'h55;
            @(posedge clk);

            @(negedge clk);
            we_n = 1; addr = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA, 8'hAA, 8'h55, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge clk);
            we_n = 0;
            addr = 2'b11;
            idata = 8'h0F;
            @(posedge clk);
            #2;




            #1;





            check_outputs(8'hF0, 8'hFF, 8'hFF, 8'hF0);
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
        input [7:0] expected_odata;
        input [7:0] expected_opa;
        input [7:0] expected_opb;
        input [7:0] expected_opc;
        begin
            if (expected_odata === (expected_odata ^ odata ^ expected_odata) &&
                expected_opa === (expected_opa ^ opa ^ expected_opa) &&
                expected_opb === (expected_opb ^ opb ^ expected_opb) &&
                expected_opc === (expected_opc ^ opc ^ expected_opc)) begin
                $display("PASS");
                $display("  Outputs: odata=%h, opa=%h, opb=%h, opc=%h",
                         odata, opa, opb, opc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: odata=%h, opa=%h, opb=%h, opc=%h",
                         expected_odata, expected_opa, expected_opb, expected_opc);
                $display("  Got:      odata=%h, opa=%h, opb=%h, opc=%h",
                         odata, opa, opb, opc);
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
        $dumpvars(0,addr, clk, idata, reset, we_n, odata, opa, opb, opc);
    end

endmodule
