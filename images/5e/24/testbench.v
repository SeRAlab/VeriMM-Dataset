`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Branch_EX;
    reg [31:0] Branch_addr_EX;
    reg Clk;
    reg [2:0] Condition_EX;
    reg Less_EX;
    reg [31:0] MemData_EX;
    reg MemRead_EX;
    reg MemWrite_EX;
    reg Overflow_EX;
    reg [4:0] Rd_EX;
    reg RegWrite_EX;
    reg [31:0] WBData_EX;
    reg Zero_EX;
    reg flush;
    reg [5:0] op_EX;
    reg stall;
    wire Branch_MEM;
    wire [31:0] Branch_addr_MEM;
    wire [2:0] Condition_MEM;
    wire Less_MEM;
    wire [31:0] MemData_MEM;
    wire MemRead_MEM;
    wire MemWrite_MEM;
    wire Overflow_MEM;
    wire [4:0] Rd_MEM;
    wire RegWrite_MEM;
    wire [31:0] WBData_MEM;
    wire Zero_MEM;
    wire [5:0] op_MEM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Branch_EX(Branch_EX),
        .Branch_addr_EX(Branch_addr_EX),
        .Clk(Clk),
        .Condition_EX(Condition_EX),
        .Less_EX(Less_EX),
        .MemData_EX(MemData_EX),
        .MemRead_EX(MemRead_EX),
        .MemWrite_EX(MemWrite_EX),
        .Overflow_EX(Overflow_EX),
        .Rd_EX(Rd_EX),
        .RegWrite_EX(RegWrite_EX),
        .WBData_EX(WBData_EX),
        .Zero_EX(Zero_EX),
        .flush(flush),
        .op_EX(op_EX),
        .stall(stall),
        .Branch_MEM(Branch_MEM),
        .Branch_addr_MEM(Branch_addr_MEM),
        .Condition_MEM(Condition_MEM),
        .Less_MEM(Less_MEM),
        .MemData_MEM(MemData_MEM),
        .MemRead_MEM(MemRead_MEM),
        .MemWrite_MEM(MemWrite_MEM),
        .Overflow_MEM(Overflow_MEM),
        .Rd_MEM(Rd_MEM),
        .RegWrite_MEM(RegWrite_MEM),
        .WBData_MEM(WBData_MEM),
        .Zero_MEM(Zero_MEM),
        .op_MEM(op_MEM)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Branch_EX = 0;
            Branch_addr_EX = 0;
            Condition_EX = 0;
            Less_EX = 0;
            MemData_EX = 0;
            MemRead_EX = 0;
            MemWrite_EX = 0;
            Overflow_EX = 0;
            Rd_EX = 0;
            RegWrite_EX = 0;
            WBData_EX = 0;
            Zero_EX = 0;
            flush = 1;
            op_EX = 0;
            stall = 0;
            @(posedge Clk);
            #1;
            flush = 0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Normal Operation", test_num);

            stall = 0;
            flush = 0;
            Branch_EX = 1;
            Branch_addr_EX = 32'hDEADBEEF;
            Condition_EX = 3'h5;
            Less_EX = 1;
            MemData_EX = 32'h12345678;
            MemRead_EX = 1;
            MemWrite_EX = 0;
            Overflow_EX = 0;
            Rd_EX = 5'h1F;
            RegWrite_EX = 1;
            WBData_EX = 32'hCAFEBABE;
            Zero_EX = 0;
            op_EX = 6'h2A;

            @(posedge Clk);
            #2;

            #1;


            check_outputs(1, 32'hDEADBEEF, 3'h5, 1, 32'h12345678, 1, 0, 0, 5'h1F, 1, 32'hCAFEBABE, 0, 6'h2A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Stall Operation", test_num);


            stall = 0;
            flush = 0;
            Branch_addr_EX = 32'h11112222;
            Rd_EX = 5'h0A;
            @(posedge Clk);
            #1;


            stall = 1;
            Branch_addr_EX = 32'hFFFFFFFF;
            Rd_EX = 5'h10;
            @(posedge Clk);
            #2;


            #1;



            check_outputs(0, 32'h11112222, 0, 0, 0, 0, 0, 0, 5'h0A, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Flush Operation", test_num);


            stall = 0;
            flush = 0;
            Branch_addr_EX = 32'h55556666;
            MemRead_EX = 1;
            @(posedge Clk);
            #1;


            flush = 1;
            Branch_addr_EX = 32'hAAAAAAAA;
            @(posedge Clk);
            #2;


            #1;



            check_outputs(0, 32'h0, 0, 0, 0, 0, 0, 0, 5'h0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Flush vs Stall Priority", test_num);


            stall = 0;
            flush = 0;
            WBData_EX = 32'hBBBBCCCC;
            @(posedge Clk);
            #1;


            stall = 1;
            flush = 1;
            WBData_EX = 32'hDDDDDEEE;
            @(posedge Clk);
            #2;


            #1;



            check_outputs(0, 32'h0, 0, 0, 0, 0, 0, 0, 5'h0, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Complex Data Transition", test_num);

            stall = 0;
            flush = 0;


            Branch_addr_EX = 32'h1; Rd_EX = 5'h1;
            @(posedge Clk);
            #1;


            Branch_addr_EX = 32'h2; Rd_EX = 5'h2;
            @(posedge Clk);
            #1;


            stall = 1;
            Branch_addr_EX = 32'h3; Rd_EX = 5'h3;
            @(posedge Clk);
            #1;


            stall = 0;
            @(posedge Clk);
            #2;


            #1;



            check_outputs(0, 32'h3, 0, 0, 0, 0, 0, 0, 5'h3, 0, 0, 0, 0);
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
        input expected_Branch_MEM;
        input [31:0] expected_Branch_addr_MEM;
        input [2:0] expected_Condition_MEM;
        input expected_Less_MEM;
        input [31:0] expected_MemData_MEM;
        input expected_MemRead_MEM;
        input expected_MemWrite_MEM;
        input expected_Overflow_MEM;
        input [4:0] expected_Rd_MEM;
        input expected_RegWrite_MEM;
        input [31:0] expected_WBData_MEM;
        input expected_Zero_MEM;
        input [5:0] expected_op_MEM;
        begin
            if (expected_Branch_MEM === (expected_Branch_MEM ^ Branch_MEM ^ expected_Branch_MEM) &&
                expected_Branch_addr_MEM === (expected_Branch_addr_MEM ^ Branch_addr_MEM ^ expected_Branch_addr_MEM) &&
                expected_Condition_MEM === (expected_Condition_MEM ^ Condition_MEM ^ expected_Condition_MEM) &&
                expected_Less_MEM === (expected_Less_MEM ^ Less_MEM ^ expected_Less_MEM) &&
                expected_MemData_MEM === (expected_MemData_MEM ^ MemData_MEM ^ expected_MemData_MEM) &&
                expected_MemRead_MEM === (expected_MemRead_MEM ^ MemRead_MEM ^ expected_MemRead_MEM) &&
                expected_MemWrite_MEM === (expected_MemWrite_MEM ^ MemWrite_MEM ^ expected_MemWrite_MEM) &&
                expected_Overflow_MEM === (expected_Overflow_MEM ^ Overflow_MEM ^ expected_Overflow_MEM) &&
                expected_Rd_MEM === (expected_Rd_MEM ^ Rd_MEM ^ expected_Rd_MEM) &&
                expected_RegWrite_MEM === (expected_RegWrite_MEM ^ RegWrite_MEM ^ expected_RegWrite_MEM) &&
                expected_WBData_MEM === (expected_WBData_MEM ^ WBData_MEM ^ expected_WBData_MEM) &&
                expected_Zero_MEM === (expected_Zero_MEM ^ Zero_MEM ^ expected_Zero_MEM) &&
                expected_op_MEM === (expected_op_MEM ^ op_MEM ^ expected_op_MEM)) begin
                $display("PASS");
                $display("  Outputs: Branch_MEM=%b, Branch_addr_MEM=%h, Condition_MEM=%h, Less_MEM=%b, MemData_MEM=%h, MemRead_MEM=%b, MemWrite_MEM=%b, Overflow_MEM=%b, Rd_MEM=%h, RegWrite_MEM=%b, WBData_MEM=%h, Zero_MEM=%b, op_MEM=%h",
                         Branch_MEM, Branch_addr_MEM, Condition_MEM, Less_MEM, MemData_MEM, MemRead_MEM, MemWrite_MEM, Overflow_MEM, Rd_MEM, RegWrite_MEM, WBData_MEM, Zero_MEM, op_MEM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Branch_MEM=%b, Branch_addr_MEM=%h, Condition_MEM=%h, Less_MEM=%b, MemData_MEM=%h, MemRead_MEM=%b, MemWrite_MEM=%b, Overflow_MEM=%b, Rd_MEM=%h, RegWrite_MEM=%b, WBData_MEM=%h, Zero_MEM=%b, op_MEM=%h",
                         expected_Branch_MEM, expected_Branch_addr_MEM, expected_Condition_MEM, expected_Less_MEM, expected_MemData_MEM, expected_MemRead_MEM, expected_MemWrite_MEM, expected_Overflow_MEM, expected_Rd_MEM, expected_RegWrite_MEM, expected_WBData_MEM, expected_Zero_MEM, expected_op_MEM);
                $display("  Got:      Branch_MEM=%b, Branch_addr_MEM=%h, Condition_MEM=%h, Less_MEM=%b, MemData_MEM=%h, MemRead_MEM=%b, MemWrite_MEM=%b, Overflow_MEM=%b, Rd_MEM=%h, RegWrite_MEM=%b, WBData_MEM=%h, Zero_MEM=%b, op_MEM=%h",
                         Branch_MEM, Branch_addr_MEM, Condition_MEM, Less_MEM, MemData_MEM, MemRead_MEM, MemWrite_MEM, Overflow_MEM, Rd_MEM, RegWrite_MEM, WBData_MEM, Zero_MEM, op_MEM);
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
        $dumpvars(0,Branch_EX, Branch_addr_EX, Clk, Condition_EX, Less_EX, MemData_EX, MemRead_EX, MemWrite_EX, Overflow_EX, Rd_EX, RegWrite_EX, WBData_EX, Zero_EX, flush, op_EX, stall, Branch_MEM, Branch_addr_MEM, Condition_MEM, Less_MEM, MemData_MEM, MemRead_MEM, MemWrite_MEM, Overflow_MEM, Rd_MEM, RegWrite_MEM, WBData_MEM, Zero_MEM, op_MEM);
    end

endmodule
