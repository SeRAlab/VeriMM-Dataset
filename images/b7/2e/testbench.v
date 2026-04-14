`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] aluoute;
    reg [31:0] aluoute2;
    reg clk;
    reg memtorege;
    reg memtorege2;
    reg memwritee;
    reg memwritee2;
    reg regwritee;
    reg regwritee2;
    reg stallm;
    reg stallm2;
    reg [31:0] writedatae;
    reg [31:0] writedatae2;
    reg [4:0] writerege;
    reg [4:0] writerege2;
    wire [31:0] aluoutm;
    wire [31:0] aluoutm2;
    wire memtoregm;
    wire memtoregm2;
    wire memwritem;
    wire memwritem2;
    wire regwritem;
    wire regwritem2;
    wire [31:0] writedatam;
    wire [31:0] writedatam2;
    wire [4:0] writeregm;
    wire [4:0] writeregm2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluoute(aluoute),
        .aluoute2(aluoute2),
        .clk(clk),
        .memtorege(memtorege),
        .memtorege2(memtorege2),
        .memwritee(memwritee),
        .memwritee2(memwritee2),
        .regwritee(regwritee),
        .regwritee2(regwritee2),
        .stallm(stallm),
        .stallm2(stallm2),
        .writedatae(writedatae),
        .writedatae2(writedatae2),
        .writerege(writerege),
        .writerege2(writerege2),
        .aluoutm(aluoutm),
        .aluoutm2(aluoutm2),
        .memtoregm(memtoregm),
        .memtoregm2(memtoregm2),
        .memwritem(memwritem),
        .memwritem2(memwritem2),
        .regwritem(regwritem),
        .regwritem2(regwritem2),
        .writedatam(writedatam),
        .writedatam2(writedatam2),
        .writeregm(writeregm),
        .writeregm2(writeregm2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        aluoute = 32'h0;
        aluoute2 = 32'h0;
        memtorege = 1'b0;
        memtorege2 = 1'b0;
        memwritee = 1'b0;
        memwritee2 = 1'b0;
        regwritee = 1'b0;
        regwritee2 = 1'b0;
        stallm = 1'b0;
        stallm2 = 1'b0;
        writedatae = 32'h0;
        writedatae2 = 32'h0;
        writerege = 5'h0;
        writerege2 = 5'h0;

        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;

        aluoute = 32'hAAAA_BBBB;
        aluoute2 = 32'h1234_5678;
        writedatae = 32'hCCCC_DDDD;
        writedatae2 = 32'h8765_4321;
        writerege = 5'd10;
        writerege2 = 5'd20;
        regwritee = 1'b1;
        regwritee2 = 1'b0;
        memtorege = 1'b1;
        memtorege2 = 1'b0;
        memwritee = 1'b0;
        memwritee2 = 1'b1;
        stallm = 1'b0;
        stallm2 = 1'b0;

        @(posedge clk);
        #2;

        $display("Testcase %0d: Basic Data Transfer", test_num);
        #1;

        check_outputs(
            32'hAAAA_BBBB, 32'h1234_5678,
            1'b1, 1'b0,
            1'b0, 1'b1,
            1'b1, 1'b0,
            32'hCCCC_DDDD, 32'h8765_4321,
            5'd10, 5'd20
        );
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;


        aluoute = 32'h1111_1111;
        aluoute2 = 32'h2222_2222;
        regwritee = 1'b1;
        regwritee2 = 1'b1;
        stallm = 1'b0;
        stallm2 = 1'b0;
        @(posedge clk);
        #2;


        stallm = 1'b1;
        stallm2 = 1'b1;
        aluoute = 32'hFFFF_FFFF;
        aluoute2 = 32'hFFFF_FFFF;
        regwritee = 1'b0;
        regwritee2 = 1'b0;

        @(posedge clk);
        #2;

        $display("Testcase %0d: Stall Handling (Holding values)", test_num);

        #1;


        check_outputs(
            32'h1111_1111, 32'h2222_2222,
            1'b0, 1'b0,
            1'b0, 1'b0,
            1'b1, 1'b1,
            32'h0, 32'h0,
            5'h0, 5'h0
        );
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;


        stallm = 1'b1;
        stallm2 = 1'b1;
        aluoute = 32'hDEAD_BEEF;
        aluoute2 = 32'hBEEF_CAFE;
        writerege = 5'd31;
        writerege2 = 5'd15;

        @(posedge clk);
        #2;


        stallm = 1'b0;
        stallm2 = 1'b0;

        @(posedge clk);
        #2;

        $display("Testcase %0d: Stall Release", test_num);
        #1;

        check_outputs(
            32'hDEAD_BEEF, 32'hBEEF_CAFE,
            1'b0, 1'b0,
            1'b0, 1'b0,
            1'b0, 1'b0,
            32'h0, 32'h0,
            5'd31, 5'd15
        );
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;


        aluoute = 32'h0000_1111;
        aluoute2 = 32'h0000_2222;
        @(posedge clk);
        #2;


        stallm = 1'b1;
        stallm2 = 1'b0;
        aluoute = 32'hAAAA_AAAA;
        aluoute2 = 32'hBBBB_BBBB;

        @(posedge clk);
        #2;

        $display("Testcase %0d: Independent Stall Control", test_num);

        #1;


        check_outputs(
            32'h0000_1111, 32'hBBBB_BBBB,
            1'b0, 1'b0,
            1'b0, 1'b0,
            1'b0, 1'b0,
            32'h0, 32'h0,
            5'h0, 5'h0
        );
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;

        aluoute = 32'h1;
        aluoute2 = 32'h2;
        memtorege = 1'b1;
        memtorege2 = 1'b1;
        memwritee = 1'b1;
        memwritee2 = 1'b1;
        regwritee = 1'b1;
        regwritee2 = 1'b1;
        writerege = 5'd5;
        writerege2 = 5'd6;
        writedatae = 32'h55;
        writedatae2 = 32'h66;

        @(posedge clk);
        #2;

        $display("Testcase %0d: All Control Flags Verification", test_num);
        #1;

        check_outputs(
            32'h1, 32'h2,
            1'b1, 1'b1,
            1'b1, 1'b1,
            1'b1, 1'b1,
            32'h55, 32'h66,
            5'd5, 5'd6
        );
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
        input [31:0] expected_aluoutm;
        input [31:0] expected_aluoutm2;
        input expected_memtoregm;
        input expected_memtoregm2;
        input expected_memwritem;
        input expected_memwritem2;
        input expected_regwritem;
        input expected_regwritem2;
        input [31:0] expected_writedatam;
        input [31:0] expected_writedatam2;
        input [4:0] expected_writeregm;
        input [4:0] expected_writeregm2;
        begin
            if (expected_aluoutm === (expected_aluoutm ^ aluoutm ^ expected_aluoutm) &&
                expected_aluoutm2 === (expected_aluoutm2 ^ aluoutm2 ^ expected_aluoutm2) &&
                expected_memtoregm === (expected_memtoregm ^ memtoregm ^ expected_memtoregm) &&
                expected_memtoregm2 === (expected_memtoregm2 ^ memtoregm2 ^ expected_memtoregm2) &&
                expected_memwritem === (expected_memwritem ^ memwritem ^ expected_memwritem) &&
                expected_memwritem2 === (expected_memwritem2 ^ memwritem2 ^ expected_memwritem2) &&
                expected_regwritem === (expected_regwritem ^ regwritem ^ expected_regwritem) &&
                expected_regwritem2 === (expected_regwritem2 ^ regwritem2 ^ expected_regwritem2) &&
                expected_writedatam === (expected_writedatam ^ writedatam ^ expected_writedatam) &&
                expected_writedatam2 === (expected_writedatam2 ^ writedatam2 ^ expected_writedatam2) &&
                expected_writeregm === (expected_writeregm ^ writeregm ^ expected_writeregm) &&
                expected_writeregm2 === (expected_writeregm2 ^ writeregm2 ^ expected_writeregm2)) begin
                $display("PASS");
                $display("  Outputs: aluoutm=%h, aluoutm2=%h, memtoregm=%b, memtoregm2=%b, memwritem=%b, memwritem2=%b, regwritem=%b, regwritem2=%b, writedatam=%h, writedatam2=%h, writeregm=%h, writeregm2=%h",
                         aluoutm, aluoutm2, memtoregm, memtoregm2, memwritem, memwritem2, regwritem, regwritem2, writedatam, writedatam2, writeregm, writeregm2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluoutm=%h, aluoutm2=%h, memtoregm=%b, memtoregm2=%b, memwritem=%b, memwritem2=%b, regwritem=%b, regwritem2=%b, writedatam=%h, writedatam2=%h, writeregm=%h, writeregm2=%h",
                         expected_aluoutm, expected_aluoutm2, expected_memtoregm, expected_memtoregm2, expected_memwritem, expected_memwritem2, expected_regwritem, expected_regwritem2, expected_writedatam, expected_writedatam2, expected_writeregm, expected_writeregm2);
                $display("  Got:      aluoutm=%h, aluoutm2=%h, memtoregm=%b, memtoregm2=%b, memwritem=%b, memwritem2=%b, regwritem=%b, regwritem2=%b, writedatam=%h, writedatam2=%h, writeregm=%h, writeregm2=%h",
                         aluoutm, aluoutm2, memtoregm, memtoregm2, memwritem, memwritem2, regwritem, regwritem2, writedatam, writedatam2, writeregm, writeregm2);
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
        $dumpvars(0,aluoute, aluoute2, clk, memtorege, memtorege2, memwritee, memwritee2, regwritee, regwritee2, stallm, stallm2, writedatae, writedatae2, writerege, writerege2, aluoutm, aluoutm2, memtoregm, memtoregm2, memwritem, memwritem2, regwritem, regwritem2, writedatam, writedatam2, writeregm, writeregm2);
    end

endmodule
