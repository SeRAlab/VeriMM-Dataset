`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] aluCtrl2_i;
    reg clk;
    reg [31:0] dataInput_i;
    reg [31:0] dataOutput_i;
    reg link2_i;
    reg memtoReg2_i;
    reg regWrite2_i;
    reg syscallFlag2_i;
    reg [4:0] writeReg2_i;
    wire [5:0] aluCtrl3_o;
    wire [31:0] dataInput1_o;
    wire [31:0] dataOutput1_o;
    wire link3_o;
    wire memtoReg3_o;
    wire regWrite3_o;
    wire syscallFlag3_o;
    wire [4:0] writeReg3_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluCtrl2_i(aluCtrl2_i),
        .clk(clk),
        .dataInput_i(dataInput_i),
        .dataOutput_i(dataOutput_i),
        .link2_i(link2_i),
        .memtoReg2_i(memtoReg2_i),
        .regWrite2_i(regWrite2_i),
        .syscallFlag2_i(syscallFlag2_i),
        .writeReg2_i(writeReg2_i),
        .aluCtrl3_o(aluCtrl3_o),
        .dataInput1_o(dataInput1_o),
        .dataOutput1_o(dataOutput1_o),
        .link3_o(link3_o),
        .memtoReg3_o(memtoReg3_o),
        .regWrite3_o(regWrite3_o),
        .syscallFlag3_o(syscallFlag3_o),
        .writeReg3_o(writeReg3_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            syscallFlag2_i = 0;
            dataInput_i = 0;
            dataOutput_i = 0;
            aluCtrl2_i = 0;
            writeReg2_i = 0;
            memtoReg2_i = 0;
            regWrite2_i = 0;
            link2_i = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;


            syscallFlag2_i = 1;
            dataInput_i = 32'hABCD1234;
            dataOutput_i = 32'h5678EF00;
            aluCtrl2_i = 6'h2A;
            writeReg2_i = 5'd15;
            memtoReg2_i = 1;
            regWrite2_i = 1;
            link2_i = 0;


            @(posedge clk);
            #1;


            $display("Testcase %0d: Basic Propagation", test_num);
            #1;

            check_outputs(6'h2A, 32'hABCD1234, 32'h5678EF00, 1'b0, 1'b1, 1'b1, 1'b1, 5'd15);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            syscallFlag2_i = 1;
            dataInput_i = 32'hFFFFFFFF;
            dataOutput_i = 32'hFFFFFFFF;
            aluCtrl2_i = 6'h3F;
            writeReg2_i = 5'h1F;
            memtoReg2_i = 1;
            regWrite2_i = 1;
            link2_i = 1;

            @(posedge clk);
            #1;

            $display("Testcase %0d: All Bits Set", test_num);
            #1;

            check_outputs(6'h3F, 32'hFFFFFFFF, 32'hFFFFFFFF, 1'b1, 1'b1, 1'b1, 1'b1, 5'h1F);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            syscallFlag2_i = 0;
            dataInput_i = 32'h0;
            dataOutput_i = 32'h0;
            aluCtrl2_i = 6'h0;
            writeReg2_i = 5'h0;
            memtoReg2_i = 0;
            regWrite2_i = 0;
            link2_i = 0;

            @(posedge clk);
            #1;

            $display("Testcase %0d: All Bits Cleared", test_num);
            #1;

            check_outputs(6'h0, 32'h0, 32'h0, 1'b0, 1'b0, 1'b0, 1'b0, 5'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            syscallFlag2_i = 0;
            dataInput_i = 32'hAAAAAAAA;
            dataOutput_i = 32'h55555555;
            aluCtrl2_i = 6'b101010;
            writeReg2_i = 5'b01010;
            memtoReg2_i = 1;
            regWrite2_i = 0;
            link2_i = 1;

            @(posedge clk);
            #1;

            $display("Testcase %0d: Alternating Patterns", test_num);
            #1;

            check_outputs(6'b101010, 32'hAAAAAAAA, 32'h55555555, 1'b1, 1'b1, 1'b0, 1'b0, 5'b01010);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;


            syscallFlag2_i = 0;
            dataInput_i = 32'h00000004;
            dataOutput_i = 32'h10002000;
            aluCtrl2_i = 6'h08;
            writeReg2_i = 5'd31;
            memtoReg2_i = 0;
            regWrite2_i = 1;
            link2_i = 1;

            @(posedge clk);
            #1;

            $display("Testcase %0d: Jump and Link Scenario", test_num);
            #1;

            check_outputs(6'h08, 32'h00000004, 32'h10002000, 1'b1, 1'b0, 1'b1, 1'b0, 5'd31);
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
        input [5:0] expected_aluCtrl3_o;
        input [31:0] expected_dataInput1_o;
        input [31:0] expected_dataOutput1_o;
        input expected_link3_o;
        input expected_memtoReg3_o;
        input expected_regWrite3_o;
        input expected_syscallFlag3_o;
        input [4:0] expected_writeReg3_o;
        begin
            if (expected_aluCtrl3_o === (expected_aluCtrl3_o ^ aluCtrl3_o ^ expected_aluCtrl3_o) &&
                expected_dataInput1_o === (expected_dataInput1_o ^ dataInput1_o ^ expected_dataInput1_o) &&
                expected_dataOutput1_o === (expected_dataOutput1_o ^ dataOutput1_o ^ expected_dataOutput1_o) &&
                expected_link3_o === (expected_link3_o ^ link3_o ^ expected_link3_o) &&
                expected_memtoReg3_o === (expected_memtoReg3_o ^ memtoReg3_o ^ expected_memtoReg3_o) &&
                expected_regWrite3_o === (expected_regWrite3_o ^ regWrite3_o ^ expected_regWrite3_o) &&
                expected_syscallFlag3_o === (expected_syscallFlag3_o ^ syscallFlag3_o ^ expected_syscallFlag3_o) &&
                expected_writeReg3_o === (expected_writeReg3_o ^ writeReg3_o ^ expected_writeReg3_o)) begin
                $display("PASS");
                $display("  Outputs: aluCtrl3_o=%h, dataInput1_o=%h, dataOutput1_o=%h, link3_o=%b, memtoReg3_o=%b, regWrite3_o=%b, syscallFlag3_o=%b, writeReg3_o=%h",
                         aluCtrl3_o, dataInput1_o, dataOutput1_o, link3_o, memtoReg3_o, regWrite3_o, syscallFlag3_o, writeReg3_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluCtrl3_o=%h, dataInput1_o=%h, dataOutput1_o=%h, link3_o=%b, memtoReg3_o=%b, regWrite3_o=%b, syscallFlag3_o=%b, writeReg3_o=%h",
                         expected_aluCtrl3_o, expected_dataInput1_o, expected_dataOutput1_o, expected_link3_o, expected_memtoReg3_o, expected_regWrite3_o, expected_syscallFlag3_o, expected_writeReg3_o);
                $display("  Got:      aluCtrl3_o=%h, dataInput1_o=%h, dataOutput1_o=%h, link3_o=%b, memtoReg3_o=%b, regWrite3_o=%b, syscallFlag3_o=%b, writeReg3_o=%h",
                         aluCtrl3_o, dataInput1_o, dataOutput1_o, link3_o, memtoReg3_o, regWrite3_o, syscallFlag3_o, writeReg3_o);
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
        $dumpvars(0,aluCtrl2_i, clk, dataInput_i, dataOutput_i, link2_i, memtoReg2_i, regWrite2_i, syscallFlag2_i, writeReg2_i, aluCtrl3_o, dataInput1_o, dataOutput1_o, link3_o, memtoReg3_o, regWrite3_o, syscallFlag3_o, writeReg3_o);
    end

endmodule
