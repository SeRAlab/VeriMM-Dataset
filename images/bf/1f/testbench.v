`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] inData;
    reg resetn;
    reg [4:0] rs;
    reg [4:0] rt;
    reg wen;
    reg [4:0] wreg;
    wire [31:0] outA;
    wire [31:0] outB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .inData(inData),
        .resetn(resetn),
        .rs(rs),
        .rt(rt),
        .wen(wen),
        .wreg(wreg),
        .outA(outA),
        .outB(outB)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            wen = 0;
            wreg = 0;
            inData = 0;
            rs = 0;
            rt = 0;
            @(posedge clk);
            #1;
            resetn = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);

            @(posedge clk);
            #1;
            wen = 1;
            wreg = 5'd1;
            inData = 32'hABCDE001;

            @(posedge clk);
            #1;
            wen = 0;
            rs = 5'd1;
            rt = 5'd1;

            #1;
            #1;

            check_outputs(32'hABCDE001, 32'hABCDE001);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Register Write and Dual Read", test_num);


            @(posedge clk);
            #1;
            wen = 1;
            wreg = 5'd10;
            inData = 32'h12345678;


            @(posedge clk);
            #1;
            wen = 1;
            wreg = 5'd20;
            inData = 32'h87654321;

            @(posedge clk);
            #1;
            wen = 0;
            rs = 5'd10;
            rt = 5'd20;

            #1;
            #1;

            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Validation", test_num);

            @(posedge clk);
            #1;
            wen = 0;
            wreg = 5'd5;
            inData = 32'hFFFFFFFF;

            @(posedge clk);
            #1;
            rs = 5'd5;
            rt = 5'd0;

            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Register Test (R31)", test_num);

            @(posedge clk);
            #1;
            wen = 1;
            wreg = 5'd31;
            inData = 32'h55AA55AA;

            @(posedge clk);
            #1;
            wen = 0;
            rs = 5'd31;
            rt = 5'd0;

            #1;
            #1;

            check_outputs(32'h55AA55AA, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Test", test_num);


            @(posedge clk);
            #1;
            wen = 1;
            wreg = 5'd15;
            inData = 32'hAAAA_AAAA;


            @(posedge clk);
            #1;
            inData = 32'hBBBB_BBBB;

            @(posedge clk);
            #1;
            wen = 0;
            rs = 5'd15;
            rt = 5'd15;

            #1;
            #1;

            check_outputs(32'hBBBB_BBBB, 32'hBBBB_BBBB);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Verification", test_num);


            @(posedge clk);
            #1;
            wen = 1;
            wreg = 5'd7;
            inData = 32'hDEADBEEF;

            @(posedge clk);
            #1;
            resetn = 0;
            @(posedge clk);
            #1;
            resetn = 1;

            rs = 5'd7;
            rt = 5'd7;
            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
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
        input [31:0] expected_outA;
        input [31:0] expected_outB;
        begin
            if (expected_outA === (expected_outA ^ outA ^ expected_outA) &&
                expected_outB === (expected_outB ^ outB ^ expected_outB)) begin
                $display("PASS");
                $display("  Outputs: outA=%h, outB=%h",
                         outA, outB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outA=%h, outB=%h",
                         expected_outA, expected_outB);
                $display("  Got:      outA=%h, outB=%h",
                         outA, outB);
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
        $dumpvars(0,clk, inData, resetn, rs, rt, wen, wreg, outA, outB);
    end

endmodule
