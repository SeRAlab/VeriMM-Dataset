`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] MEM_ALU_DataBus;
    reg [4:0] MEM_Reg_RD;
    reg MEM_WB_RegWre;
    reg RST;
    wire [31:0] WB_DataBus;
    wire WB_RegWre;
    wire [4:0] WB_Reg_RD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .MEM_ALU_DataBus(MEM_ALU_DataBus),
        .MEM_Reg_RD(MEM_Reg_RD),
        .MEM_WB_RegWre(MEM_WB_RegWre),
        .RST(RST),
        .WB_DataBus(WB_DataBus),
        .WB_RegWre(WB_RegWre),
        .WB_Reg_RD(WB_Reg_RD)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            MEM_WB_RegWre = 0;
            MEM_Reg_RD = 5'b0;
            MEM_ALU_DataBus = 32'b0;
            #15;
            RST = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Data Latching", test_num);
            reset_dut();


            MEM_WB_RegWre = 1'b1;
            MEM_Reg_RD = 5'd10;
            MEM_ALU_DataBus = 32'hA5A5A5A5;

            @(posedge CLK);
            #2;

            #1;


            check_outputs(32'hA5A5A5A5, 1'b1, 5'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Latching Control Signal Low", test_num);
            reset_dut();

            MEM_WB_RegWre = 1'b0;
            MEM_Reg_RD = 5'd31;
            MEM_ALU_DataBus = 32'hFFFFFFFF;

            @(posedge CLK);
            #2;

            #1;


            check_outputs(32'hFFFFFFFF, 1'b0, 5'd31);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Sequential Data Flow", test_num);
            reset_dut();


            MEM_WB_RegWre = 1'b1;
            MEM_Reg_RD = 5'd5;
            MEM_ALU_DataBus = 32'h12345678;
            @(posedge CLK);


            #1;
            MEM_WB_RegWre = 1'b0;
            MEM_Reg_RD = 5'd15;
            MEM_ALU_DataBus = 32'h87654321;
            @(posedge CLK);
            #2;


            #1;



            check_outputs(32'h87654321, 1'b0, 5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Asynchronous Reset Mid-Operation", test_num);
            reset_dut();


            MEM_WB_RegWre = 1'b1;
            MEM_Reg_RD = 5'd20;
            MEM_ALU_DataBus = 32'hBCBCBCBC;
            @(posedge CLK);
            #2;


            #3;
            RST = 1;
            #5;


            #1;



            check_outputs(32'h0, 1'b0, 5'h0);
            RST = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary Value Test (All 1s)", test_num);
            reset_dut();

            MEM_WB_RegWre = 1'b1;
            MEM_Reg_RD = 5'b11111;
            MEM_ALU_DataBus = 32'hFFFFFFFF;

            @(posedge CLK);
            #2;

            #1;


            check_outputs(32'hFFFFFFFF, 1'b1, 5'b11111);
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
        input [31:0] expected_WB_DataBus;
        input expected_WB_RegWre;
        input [4:0] expected_WB_Reg_RD;
        begin
            if (expected_WB_DataBus === (expected_WB_DataBus ^ WB_DataBus ^ expected_WB_DataBus) &&
                expected_WB_RegWre === (expected_WB_RegWre ^ WB_RegWre ^ expected_WB_RegWre) &&
                expected_WB_Reg_RD === (expected_WB_Reg_RD ^ WB_Reg_RD ^ expected_WB_Reg_RD)) begin
                $display("PASS");
                $display("  Outputs: WB_DataBus=%h, WB_RegWre=%b, WB_Reg_RD=%h",
                         WB_DataBus, WB_RegWre, WB_Reg_RD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WB_DataBus=%h, WB_RegWre=%b, WB_Reg_RD=%h",
                         expected_WB_DataBus, expected_WB_RegWre, expected_WB_Reg_RD);
                $display("  Got:      WB_DataBus=%h, WB_RegWre=%b, WB_Reg_RD=%h",
                         WB_DataBus, WB_RegWre, WB_Reg_RD);
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
        $dumpvars(0,CLK, MEM_ALU_DataBus, MEM_Reg_RD, MEM_WB_RegWre, RST, WB_DataBus, WB_RegWre, WB_Reg_RD);
    end

endmodule
