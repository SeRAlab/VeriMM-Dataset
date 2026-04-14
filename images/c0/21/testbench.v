`timescale 1ns/1ps

module RegisterFile_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] ReadReg1;
    reg [4:0] ReadReg2;
    reg RegWrite;
    reg [31:0] WriteData;
    reg [4:0] WriteReg;
    reg clock;
    reg reset;
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RegisterFile dut (
        .ReadReg1(ReadReg1),
        .ReadReg2(ReadReg2),
        .RegWrite(RegWrite),
        .WriteData(WriteData),
        .WriteReg(WriteReg),
        .clock(clock),
        .reset(reset),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            ReadReg1 = 0;
            ReadReg2 = 0;
            RegWrite = 0;
            WriteData = 0;
            WriteReg = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify Reset State", test_num);
            reset_dut();
            ReadReg1 = 5;
            ReadReg2 = 10;
            #2;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            RegWrite = 1;
            WriteReg = 5'd1;
            WriteData = 32'hDEADBEEF;
            @(posedge clock);
            #1;
            RegWrite = 0;


            ReadReg1 = 5'd1;
            ReadReg2 = 5'd2;
            #2;
            #1;

            check_outputs(32'hDEADBEEF, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Register 0 Hardwired to Zero", test_num);
            reset_dut();


            RegWrite = 1;
            WriteReg = 5'd0;
            WriteData = 32'hFFFFFFFF;
            @(posedge clock);
            #1;
            RegWrite = 0;

            ReadReg1 = 5'd0;
            ReadReg2 = 5'd0;
            #2;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write Enable Control", test_num);
            reset_dut();


            RegWrite = 0;
            WriteReg = 5'd15;
            WriteData = 32'h12345678;
            @(posedge clock);
            #1;

            ReadReg1 = 5'd15;
            ReadReg2 = 5'd0;
            #2;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Dual Read Operation", test_num);
            reset_dut();


            RegWrite = 1;
            WriteReg = 5'd10;
            WriteData = 32'hAAAA_BBBB;
            @(posedge clock);
            #1;


            WriteReg = 5'd20;
            WriteData = 32'hCCCC_DDDD;
            @(posedge clock);
            #1;
            RegWrite = 0;


            ReadReg1 = 5'd10;
            ReadReg2 = 5'd20;
            #2;
            #1;

            check_outputs(32'hAAAA_BBBB, 32'hCCCC_DDDD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary Register Test (Reg 31)", test_num);
            reset_dut();

            RegWrite = 1;
            WriteReg = 5'd31;
            WriteData = 32'h87654321;
            @(posedge clock);
            #1;
            RegWrite = 0;

            ReadReg1 = 5'd31;
            ReadReg2 = 5'd31;
            #2;
            #1;

            check_outputs(32'h87654321, 32'h87654321);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Overwriting a Register", test_num);
            reset_dut();


            RegWrite = 1;
            WriteReg = 5'd7;
            WriteData = 32'h1111_1111;
            @(posedge clock);
            #1;


            WriteData = 32'h2222_2222;
            @(posedge clock);
            #1;
            RegWrite = 0;

            ReadReg1 = 5'd7;
            ReadReg2 = 5'd7;
            #2;
            #1;

            check_outputs(32'h2222_2222, 32'h2222_2222);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RegisterFile Testbench");
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
        $dumpvars(0,ReadReg1, ReadReg2, RegWrite, WriteData, WriteReg, clock, reset, ReadData1, ReadData2);
    end

endmodule
