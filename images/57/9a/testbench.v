`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] ReadReg1;
    reg [4:0] ReadReg2;
    reg RegWrite;
    reg [31:0] WriteData;
    reg [4:0] WriteReg;
    reg clk;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ReadReg1(ReadReg1),
        .ReadReg2(ReadReg2),
        .RegWrite(RegWrite),
        .WriteData(WriteData),
        .WriteReg(WriteReg),
        .clk(clk),
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
            ReadReg1 = 5'd0;
            ReadReg2 = 5'd0;
            WriteReg = 5'd0;
            WriteData = 32'd0;
            RegWrite = 1'b0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Basic Write and Read (Reg 1)", test_num);

            @(negedge clk);
            RegWrite = 1'b1;
            WriteReg = 5'd1;
            WriteData = 32'hDEADBEEF;

            @(posedge clk);
            #1;
            RegWrite = 1'b0;
            ReadReg1 = 5'd1;
            ReadReg2 = 5'd0;
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Register 0 Hardwired Check", test_num);

            @(negedge clk);
            RegWrite = 1'b1;
            WriteReg = 5'd0;
            WriteData = 32'hFFFFFFFF;

            @(posedge clk);
            #1;
            RegWrite = 1'b0;
            ReadReg1 = 5'd0;
            ReadReg2 = 5'd0;
            #1;

            #1;


            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: RegWrite Enable Control Check", test_num);



            @(negedge clk);
            RegWrite = 1'b0;
            WriteReg = 5'd10;
            WriteData = 32'h12345678;

            @(posedge clk);
            #1;
            ReadReg1 = 5'd10;
            ReadReg2 = 5'd0;
            #1;


            if (ReadData1 == 32'h12345678) begin
                $display("FAIL: Data written while RegWrite was low");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Data not written while RegWrite was low");
                pass_count = pass_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Dual Port Simultaneous Read", test_num);


            @(negedge clk);
            RegWrite = 1'b1; WriteReg = 5'd20; WriteData = 32'hAAAA5555;
            @(posedge clk);


            @(negedge clk);
            RegWrite = 1'b1; WriteReg = 5'd21; WriteData = 32'h12344321;
            @(posedge clk);

            #1;
            RegWrite = 1'b0;
            ReadReg1 = 5'd20;
            ReadReg2 = 5'd21;
            #1;
            #1;

            check_outputs(32'hAAAA5555, 32'h12344321);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Boundary Register 31 Check", test_num);

            @(negedge clk);
            RegWrite = 1'b1;
            WriteReg = 5'd31;
            WriteData = 32'h77778888;

            @(posedge clk);
            #1;
            RegWrite = 1'b0;
            ReadReg1 = 5'd31;
            ReadReg2 = 5'd31;
            #1;
            #1;

            check_outputs(32'h77778888, 32'h77778888);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Data Overwrite Check", test_num);


            @(negedge clk);
            RegWrite = 1'b1; WriteReg = 5'd15; WriteData = 32'h11111111;
            @(posedge clk);


            @(negedge clk);
            RegWrite = 1'b1; WriteReg = 5'd15; WriteData = 32'h22222222;
            @(posedge clk);

            #1;
            RegWrite = 1'b0;
            ReadReg1 = 5'd15;
            ReadReg2 = 5'd0;
            #1;
            #1;

            check_outputs(32'h22222222, 32'h00000000);
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
        $dumpvars(0,ReadReg1, ReadReg2, RegWrite, WriteData, WriteReg, clk, ReadData1, ReadData2);
    end

endmodule
