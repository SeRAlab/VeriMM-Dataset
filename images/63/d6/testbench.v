`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] ReadRegID1;
    reg [5:0] ReadRegID2;
    reg [31:0] WriteData;
    reg [5:0] WriteRegID;
    reg clk;
    reg write;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ReadRegID1(ReadRegID1),
        .ReadRegID2(ReadRegID2),
        .WriteData(WriteData),
        .WriteRegID(WriteRegID),
        .clk(clk),
        .write(write),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        ReadRegID1 = 0;
        ReadRegID2 = 0;
        WriteData = 0;
        WriteRegID = 0;
        write = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase %0d: Write to Reg 1 and Read back", test_num);


        @(negedge clk);
        write = 1;
        WriteRegID = 1;
        WriteData = 32'hDEADBEEF;
        @(negedge clk);
        write = 0;


        ReadRegID1 = 1;
        ReadRegID2 = 1;
        #2;
        #1;

        check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase %0d: Verify Reg 0 is always 0", test_num);


        @(negedge clk);
        write = 1;
        WriteRegID = 0;
        WriteData = 32'hFFFFFFFF;
        @(negedge clk);
        write = 0;


        ReadRegID1 = 0;
        ReadRegID2 = 1;
        #2;
        #1;

        check_outputs(32'h00000000, 32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase %0d: Verify Write Enable functionality", test_num);


        @(negedge clk);
        write = 0;
        WriteRegID = 2;
        WriteData = 32'h12345678;
        @(negedge clk);


        ReadRegID1 = 2;
        ReadRegID2 = 0;
        #2;
        #1;

        check_outputs(32'h00000000, 32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase %0d: Simultaneous read from Reg 3 and Reg 4", test_num);


        @(negedge clk);
        write = 1;
        WriteRegID = 3;
        WriteData = 32'hAAAA5555;
        @(negedge clk);


        WriteRegID = 4;
        WriteData = 32'h5555AAAA;
        @(negedge clk);
        write = 0;


        ReadRegID1 = 3;
        ReadRegID2 = 4;
        #2;
        #1;

        check_outputs(32'hAAAA5555, 32'h5555AAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase %0d: Out of bounds WriteRegID check", test_num);


        @(negedge clk);
        write = 1;
        WriteRegID = 6;
        WriteData = 32'hBAD0BADA;
        @(negedge clk);
        write = 0;


        ReadRegID1 = 6;
        ReadRegID2 = 5;
        #2;


        #1;



        check_outputs(ReadData1, 32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Testcase %0d: Max register index (Reg 5) write/read", test_num);

        @(negedge clk);
        write = 1;
        WriteRegID = 5;
        WriteData = 32'hFEEDFACE;
        @(negedge clk);
        write = 0;

        ReadRegID1 = 5;
        ReadRegID2 = 0;
        #2;
        #1;

        check_outputs(32'hFEEDFACE, 32'h00000000);
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
        input [31:0] expected_ReadData1;
        input [31:0] expected_ReadData2;
        begin
            if (expected_ReadData1 === (expected_ReadData1 ^ ReadData1 ^ expected_ReadData1) &&
                expected_ReadData2 === (expected_ReadData2 ^ ReadData2 ^ expected_ReadData2)) begin
                $display("PASS");
                $display("  Outputs: ReadData1=%h, ReadData2=%h",
                         ReadData1, ReadData2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ReadData1=%h, ReadData2=%h",
                         expected_ReadData1, expected_ReadData2);
                $display("  Got:      ReadData1=%h, ReadData2=%h",
                         ReadData1, ReadData2);
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
        $dumpvars(0,ReadRegID1, ReadRegID2, WriteData, WriteRegID, clk, write, ReadData1, ReadData2);
    end

endmodule
