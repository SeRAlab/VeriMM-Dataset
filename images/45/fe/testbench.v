`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] datain;
    reg reset;
    reg [4:0] rna;
    reg [4:0] rnb;
    reg [4:0] wn;
    reg wreg;
    wire [31:0] qa;
    wire [31:0] qb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datain(datain),
        .reset(reset),
        .rna(rna),
        .rnb(rnb),
        .wn(wn),
        .wreg(wreg),
        .qa(qa),
        .qb(qb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 0;
            wreg = 0;
            wn = 0;
            datain = 0;
            rna = 0;
            rnb = 0;
            #10;
            reset = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Post-Reset Verification", test_num);
            reset_dut();


            rna = 5;
            rnb = 31;
            #5;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write and Read (Reg 1)", test_num);
            reset_dut();


            @(posedge clk);
            wn = 5'd1;
            datain = 32'hDEADBEEF;
            wreg = 1;
            @(posedge clk);
            wreg = 0;


            rna = 5'd1;
            rnb = 5'd0;
            #5;
            #1;

            check_outputs(32'hDEADBEEF, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simultaneous Read (Reg 10 and 20)", test_num);
            reset_dut();


            @(posedge clk);
            wn = 5'd10;
            datain = 32'hAAAA_5555;
            wreg = 1;
            @(posedge clk);


            wn = 5'd20;
            datain = 32'h1234_5678;
            @(posedge clk);
            wreg = 0;


            rna = 5'd10;
            rnb = 5'd20;
            #5;
            #1;

            check_outputs(32'hAAAA_5555, 32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Register 0 Hardwired to Zero", test_num);
            reset_dut();


            @(posedge clk);
            wn = 5'd0;
            datain = 32'hFFFF_FFFF;
            wreg = 1;
            @(posedge clk);
            wreg = 0;


            rna = 5'd0;
            rnb = 5'd0;
            #5;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Write Enable Control", test_num);
            reset_dut();


            @(posedge clk);
            wn = 5'd15;
            datain = 32'h1111_1111;
            wreg = 1;
            @(posedge clk);


            wn = 5'd15;
            datain = 32'hEEEE_EEEE;
            wreg = 0;
            @(posedge clk);


            rna = 5'd15;
            rnb = 5'd0;
            #5;
            #1;

            check_outputs(32'h1111_1111, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Maximum Register Address (31)", test_num);
            reset_dut();

            @(posedge clk);
            wn = 5'd31;
            datain = 32'h8765_4321;
            wreg = 1;
            @(posedge clk);
            wreg = 0;

            rna = 5'd31;
            rnb = 5'd0;
            #5;
            #1;

            check_outputs(32'h8765_4321, 32'h0);
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
        input [31:0] expected_qa;
        input [31:0] expected_qb;
        begin
            if (expected_qa === (expected_qa ^ qa ^ expected_qa) &&
                expected_qb === (expected_qb ^ qb ^ expected_qb)) begin
                $display("PASS");
                $display("  Outputs: qa=%h, qb=%h",
                         qa, qb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: qa=%h, qb=%h",
                         expected_qa, expected_qb);
                $display("  Got:      qa=%h, qb=%h",
                         qa, qb);
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
        $dumpvars(0,clk, datain, reset, rna, rnb, wn, wreg, qa, qb);
    end

endmodule
