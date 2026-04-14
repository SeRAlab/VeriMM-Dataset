`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a_en;
    reg [4:0] a_reg;
    reg b_en;
    reg [4:0] b_reg;
    reg [4:0] c_reg;
    reg c_we;
    reg [31:0] c_writedatain;
    reg clk;
    reg resetn;
    wire [31:0] a_readdataout;
    wire [31:0] b_readdataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_en(a_en),
        .a_reg(a_reg),
        .b_en(b_en),
        .b_reg(b_reg),
        .c_reg(c_reg),
        .c_we(c_we),
        .c_writedatain(c_writedatain),
        .clk(clk),
        .resetn(resetn),
        .a_readdataout(a_readdataout),
        .b_readdataout(b_readdataout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            a_en = 0;
            a_reg = 0;
            b_en = 0;
            b_reg = 0;
            c_we = 0;
            c_reg = 0;
            c_writedatain = 0;
            #15;
            resetn = 1;
            #5;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State Verification", test_num);
            reset_dut();


            a_en = 1;
            a_reg = 5'd10;
            b_en = 1;
            b_reg = 5'd20;

            #5;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Basic Write and Read (Reg 5)", test_num);
            reset_dut();


            @(posedge clk);
            c_we = 1;
            c_reg = 5'd5;
            c_writedatain = 32'hDEADBEEF;
            @(posedge clk);
            c_we = 0;


            a_en = 1;
            a_reg = 5'd5;
            b_en = 0;

            #5;
            #1;

            check_outputs(32'hDEADBEEF, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Dual Port Simultaneous Read", test_num);
            reset_dut();


            @(posedge clk);
            c_we = 1;
            c_reg = 5'd1;
            c_writedatain = 32'h11111111;
            @(posedge clk);


            c_reg = 5'd2;
            c_writedatain = 32'h22222222;
            @(posedge clk);
            c_we = 0;


            a_en = 1;
            a_reg = 5'd1;
            b_en = 1;
            b_reg = 5'd2;

            #5;
            #1;

            check_outputs(32'h11111111, 32'h22222222);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Write Enable Control Check", test_num);
            reset_dut();


            @(posedge clk);
            c_we = 0;
            c_reg = 5'd10;
            c_writedatain = 32'h55555555;
            @(posedge clk);


            a_en = 1;
            a_reg = 5'd10;
            b_en = 0;

            #5;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Read Port Enable Check", test_num);
            reset_dut();


            @(posedge clk);
            c_we = 1;
            c_reg = 5'd15;
            c_writedatain = 32'hAAAAAAAA;
            @(posedge clk);
            c_we = 0;


            a_en = 0;
            a_reg = 5'd15;
            b_en = 0;
            b_reg = 5'd15;

            #5;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Boundary Register Check (Reg 31)", test_num);
            reset_dut();


            @(posedge clk);
            c_we = 1;
            c_reg = 5'd31;
            c_writedatain = 32'hFFFFFFFF;
            @(posedge clk);
            c_we = 0;


            a_en = 1;
            a_reg = 5'd31;
            b_en = 1;
            b_reg = 5'd31;

            #5;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF);
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
        input [31:0] expected_a_readdataout;
        input [31:0] expected_b_readdataout;
        begin
            if (expected_a_readdataout === (expected_a_readdataout ^ a_readdataout ^ expected_a_readdataout) &&
                expected_b_readdataout === (expected_b_readdataout ^ b_readdataout ^ expected_b_readdataout)) begin
                $display("PASS");
                $display("  Outputs: a_readdataout=%h, b_readdataout=%h",
                         a_readdataout, b_readdataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_readdataout=%h, b_readdataout=%h",
                         expected_a_readdataout, expected_b_readdataout);
                $display("  Got:      a_readdataout=%h, b_readdataout=%h",
                         a_readdataout, b_readdataout);
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
        $dumpvars(0,a_en, a_reg, b_en, b_reg, c_reg, c_we, c_writedatain, clk, resetn, a_readdataout, b_readdataout);
    end

endmodule
