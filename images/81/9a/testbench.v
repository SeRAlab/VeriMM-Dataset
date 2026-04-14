`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] ALUout;
    reg [12:0] SW;
    reg [31:0] XM_MD;
    reg XM_MemRead;
    reg XM_MemWrite;
    reg XM_MemtoReg;
    reg [4:0] XM_RD;
    reg XM_RegWrite;
    reg clk;
    reg rst;
    wire [31:0] MDR;
    wire [31:0] MW_ALUout;
    wire MW_MemtoReg;
    wire [4:0] MW_RD;
    wire MW_RegWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUout(ALUout),
        .SW(SW),
        .XM_MD(XM_MD),
        .XM_MemRead(XM_MemRead),
        .XM_MemWrite(XM_MemWrite),
        .XM_MemtoReg(XM_MemtoReg),
        .XM_RD(XM_RD),
        .XM_RegWrite(XM_RegWrite),
        .clk(clk),
        .rst(rst),
        .MDR(MDR),
        .MW_ALUout(MW_ALUout),
        .MW_MemtoReg(MW_MemtoReg),
        .MW_RD(MW_RD),
        .MW_RegWrite(MW_RegWrite)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ALUout = 0;
            SW = 13'h0;
            XM_MD = 0;
            XM_MemRead = 0;
            XM_MemWrite = 0;
            XM_MemtoReg = 0;
            XM_RD = 0;
            XM_RegWrite = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Initialization", test_num);


            SW = 13'h1ABC;
            rst = 1;
            @(posedge clk);
            #1 rst = 0;


            XM_MemRead = 1;
            ALUout = 32'h0;
            XM_RD = 5'd10;
            XM_RegWrite = 1;
            XM_MemtoReg = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h1ABC, 32'h0, 1'b0, 5'd10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Initialization (Addr 1)", test_num);

            SW = 13'h0FFF;
            reset_dut();



            rst = 1; SW = 13'h0FFF; @(posedge clk); #1 rst = 0;

            XM_MemRead = 1;
            ALUout = 32'h1;
            XM_RD = 5'd5;
            XM_RegWrite = 0;
            XM_MemtoReg = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0FFF, 32'h1, 1'b1, 5'd5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Memory Write and Read back", test_num);
            reset_dut();


            XM_MemWrite = 1;
            ALUout = 32'h20;
            XM_MD = 32'hDEADBEEF;
            XM_RD = 5'd15;
            @(posedge clk);


            #1;
            XM_MemWrite = 0;
            XM_MemRead = 1;
            ALUout = 32'h20;
            XM_RD = 5'd20;
            @(posedge clk);

            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'h20, 1'b0, 5'd20, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pipeline Control Signal Propagation", test_num);
            reset_dut();

            XM_MemRead = 0;
            XM_MemWrite = 0;
            XM_MemtoReg = 1;
            XM_RegWrite = 1;
            XM_RD = 5'd31;
            ALUout = 32'hAAAA5555;

            @(posedge clk);
            #1;




            #1;





            check_outputs(MDR, 32'hAAAA5555, 1'b1, 5'd31, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address (Addr 127)", test_num);
            reset_dut();


            XM_MemWrite = 1;
            ALUout = 32'hFFFFFF7F;
            XM_MD = 32'h12345678;
            @(posedge clk);

            #1;
            XM_MemWrite = 0;
            XM_MemRead = 1;
            ALUout = 32'h0000007F;
            @(posedge clk);

            #1;
            #1;

            check_outputs(32'h12345678, 32'h7F, 1'b0, 5'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify Memory[2] is Zero", test_num);
            reset_dut();

            XM_MemRead = 1;
            ALUout = 32'h2;
            @(posedge clk);

            #1;
            #1;

            check_outputs(32'h0, 32'h2, 1'b0, 5'd0, 1'b0);
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
        input [31:0] expected_MDR;
        input [31:0] expected_MW_ALUout;
        input expected_MW_MemtoReg;
        input [4:0] expected_MW_RD;
        input expected_MW_RegWrite;
        begin
            if (expected_MDR === (expected_MDR ^ MDR ^ expected_MDR) &&
                expected_MW_ALUout === (expected_MW_ALUout ^ MW_ALUout ^ expected_MW_ALUout) &&
                expected_MW_MemtoReg === (expected_MW_MemtoReg ^ MW_MemtoReg ^ expected_MW_MemtoReg) &&
                expected_MW_RD === (expected_MW_RD ^ MW_RD ^ expected_MW_RD) &&
                expected_MW_RegWrite === (expected_MW_RegWrite ^ MW_RegWrite ^ expected_MW_RegWrite)) begin
                $display("PASS");
                $display("  Outputs: MDR=%h, MW_ALUout=%h, MW_MemtoReg=%b, MW_RD=%h, MW_RegWrite=%b",
                         MDR, MW_ALUout, MW_MemtoReg, MW_RD, MW_RegWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MDR=%h, MW_ALUout=%h, MW_MemtoReg=%b, MW_RD=%h, MW_RegWrite=%b",
                         expected_MDR, expected_MW_ALUout, expected_MW_MemtoReg, expected_MW_RD, expected_MW_RegWrite);
                $display("  Got:      MDR=%h, MW_ALUout=%h, MW_MemtoReg=%b, MW_RD=%h, MW_RegWrite=%b",
                         MDR, MW_ALUout, MW_MemtoReg, MW_RD, MW_RegWrite);
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
        $dumpvars(0,ALUout, SW, XM_MD, XM_MemRead, XM_MemWrite, XM_MemtoReg, XM_RD, XM_RegWrite, clk, rst, MDR, MW_ALUout, MW_MemtoReg, MW_RD, MW_RegWrite);
    end

endmodule
