`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg DBDataSrc;
    reg clk;
    reg [31:0] ramdata;
    reg [31:0] reg1;
    reg [31:0] reg2;
    reg [31:0] result;
    wire [31:0] aluA;
    wire [31:0] aluB;
    wire [31:0] ramadd;
    wire [31:0] wdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DBDataSrc(DBDataSrc),
        .clk(clk),
        .ramdata(ramdata),
        .reg1(reg1),
        .reg2(reg2),
        .result(result),
        .aluA(aluA),
        .aluB(aluB),
        .ramadd(ramadd),
        .wdata(wdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            DBDataSrc <= 0;
            ramdata <= 0;
            reg1 <= 0;
            reg2 <= 0;
            result <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Data Forwarding (DBDataSrc = 0)");
            test_num = test_num + 1;
            reset_dut();


            reg1 <= 32'h1111_2222;
            reg2 <= 32'h3333_4444;
            result <= 32'h5555_6666;
            ramdata <= 32'h7777_8888;
            DBDataSrc <= 1'b0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h1111_2222, 32'h3333_4444, 32'h5555_6666, 32'h5555_6666);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Data Forwarding with DBDataSrc = 1");
            test_num = test_num + 1;
            reset_dut();


            reg1 <= 32'hAAAA_BBBB;
            reg2 <= 32'hCCCC_DDDD;
            result <= 32'hEEEE_FFFF;
            ramdata <= 32'h1234_5678;
            DBDataSrc <= 1'b1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hAAAA_BBBB, 32'hCCCC_DDDD, 32'hEEEE_FFFF, 32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Zero Inputs");
            test_num = test_num + 1;
            reset_dut();

            reg1 <= 32'h0;
            reg2 <= 32'h0;
            result <= 32'h0;
            ramdata <= 32'h0;
            DBDataSrc <= 1'b0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: All-Ones Inputs");
            test_num = test_num + 1;
            reset_dut();

            reg1 <= 32'hFFFF_FFFF;
            reg2 <= 32'hFFFF_FFFF;
            result <= 32'hFFFF_FFFF;
            ramdata <= 32'hFFFF_FFFF;
            DBDataSrc <= 1'b1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF, 32'hFFFF_FFFF, 32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Alternating Pattern");
            test_num = test_num + 1;
            reset_dut();

            reg1 <= 32'h5555_5555;
            reg2 <= 32'hAAAA_AAAA;
            result <= 32'hF0F0_F0F0;
            ramdata <= 32'h0F0F_0F0F;
            DBDataSrc <= 1'b0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h5555_5555, 32'hAAAA_AAAA, 32'hF0F0_F0F0, 32'hF0F0_F0F0);
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
        input [31:0] expected_aluA;
        input [31:0] expected_aluB;
        input [31:0] expected_ramadd;
        input [31:0] expected_wdata;
        begin
            if (expected_aluA === (expected_aluA ^ aluA ^ expected_aluA) &&
                expected_aluB === (expected_aluB ^ aluB ^ expected_aluB) &&
                expected_ramadd === (expected_ramadd ^ ramadd ^ expected_ramadd) &&
                expected_wdata === (expected_wdata ^ wdata ^ expected_wdata)) begin
                $display("PASS");
                $display("  Outputs: aluA=%h, aluB=%h, ramadd=%h, wdata=%h",
                         aluA, aluB, ramadd, wdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluA=%h, aluB=%h, ramadd=%h, wdata=%h",
                         expected_aluA, expected_aluB, expected_ramadd, expected_wdata);
                $display("  Got:      aluA=%h, aluB=%h, ramadd=%h, wdata=%h",
                         aluA, aluB, ramadd, wdata);
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
        $dumpvars(0,DBDataSrc, clk, ramdata, reg1, reg2, result, aluA, aluB, ramadd, wdata);
    end

endmodule
