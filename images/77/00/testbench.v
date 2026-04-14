`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RegWrite;
    reg [31:0] Wdat;
    reg clk;
    reg [4:0] regA;
    reg [4:0] regB;
    reg [4:0] regTEST;
    reg [4:0] regW;
    wire [31:0] Adat;
    wire [31:0] Bdat;
    wire [31:0] TESTdat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RegWrite(RegWrite),
        .Wdat(Wdat),
        .clk(clk),
        .regA(regA),
        .regB(regB),
        .regTEST(regTEST),
        .regW(regW),
        .Adat(Adat),
        .Bdat(Bdat),
        .TESTdat(TESTdat)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            RegWrite = 0;
            Wdat = 32'b0;
            regA = 5'b0;
            regB = 5'b0;
            regTEST = 5'b0;
            regW = 5'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            regW = 5'd5;
            Wdat = 32'hACE1ACE1;
            RegWrite = 1;
            @(posedge clk);
            #1;
            RegWrite = 0;


            regA = 5'd5;
            regB = 5'd5;
            regTEST = 5'd5;
            #2;

            $display("Testcase %0d: Basic Write/Read", test_num);
            #1;

            check_outputs(32'hACE1ACE1, 32'hACE1ACE1, 32'hACE1ACE1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            regW = 5'd0;
            Wdat = 32'hFFFFFFFF;
            RegWrite = 1;
            @(posedge clk);
            #1;
            RegWrite = 0;


            regA = 5'd0;
            regB = 5'd0;
            regTEST = 5'd0;
            #2;

            $display("Testcase %0d: Register 0 Write Protection", test_num);
            #1;

            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            regW = 5'd10;
            Wdat = 32'hCAFEBABE;
            RegWrite = 0;
            @(posedge clk);
            #1;


            regA = 5'd10;
            regB = 5'd10;
            regTEST = 5'd10;
            #2;

            $display("Testcase %0d: RegWrite Enable Signal Check", test_num);
            #1;

            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            regW = 5'd1; Wdat = 32'h11111111; RegWrite = 1;
            @(posedge clk); #1;


            regW = 5'd2; Wdat = 32'h22222222; RegWrite = 1;
            @(posedge clk); #1;


            regW = 5'd3; Wdat = 32'h33333333; RegWrite = 1;
            @(posedge clk); #1;

            RegWrite = 0;


            regA = 5'd1;
            regB = 5'd2;
            regTEST = 5'd3;
            #2;

            $display("Testcase %0d: Simultaneous Read from Different Registers", test_num);
            #1;

            check_outputs(32'h11111111, 32'h22222222, 32'h33333333);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            regW = 5'd20; Wdat = 32'hAAAA_AAAA; RegWrite = 1;
            @(posedge clk); #1;


            regW = 5'd20; Wdat = 32'h5555_5555; RegWrite = 1;
            @(posedge clk); #1;

            RegWrite = 0;
            regA = 5'd20;
            regB = 5'd20;
            regTEST = 5'd20;
            #2;

            $display("Testcase %0d: Overwriting Register Data", test_num);
            #1;

            check_outputs(32'h5555_5555, 32'h5555_5555, 32'h5555_5555);
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
        input [31:0] expected_Adat;
        input [31:0] expected_Bdat;
        input [31:0] expected_TESTdat;
        begin
            if (expected_Adat === (expected_Adat ^ Adat ^ expected_Adat) &&
                expected_Bdat === (expected_Bdat ^ Bdat ^ expected_Bdat) &&
                expected_TESTdat === (expected_TESTdat ^ TESTdat ^ expected_TESTdat)) begin
                $display("PASS");
                $display("  Outputs: Adat=%h, Bdat=%h, TESTdat=%h",
                         Adat, Bdat, TESTdat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Adat=%h, Bdat=%h, TESTdat=%h",
                         expected_Adat, expected_Bdat, expected_TESTdat);
                $display("  Got:      Adat=%h, Bdat=%h, TESTdat=%h",
                         Adat, Bdat, TESTdat);
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
        $dumpvars(0,RegWrite, Wdat, clk, regA, regB, regTEST, regW, Adat, Bdat, TESTdat);
    end

endmodule
