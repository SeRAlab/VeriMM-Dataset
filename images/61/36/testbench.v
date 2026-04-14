`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg Clrn;
    reg [31:0] M_ALUR;
    reg [31:0] M_Dout;
    reg [4:0] M_Rd;
    reg M_Reg2reg;
    reg M_Wreg;
    wire [31:0] W_ALUR;
    wire [31:0] W_Dout;
    wire [4:0] W_Rd;
    wire W_Reg2reg;
    wire W_Wreg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .Clrn(Clrn),
        .M_ALUR(M_ALUR),
        .M_Dout(M_Dout),
        .M_Rd(M_Rd),
        .M_Reg2reg(M_Reg2reg),
        .M_Wreg(M_Wreg),
        .W_ALUR(W_ALUR),
        .W_Dout(W_Dout),
        .W_Rd(W_Rd),
        .W_Reg2reg(W_Reg2reg),
        .W_Wreg(W_Wreg)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Clrn = 0;
            M_ALUR = 0;
            M_Dout = 0;
            M_Rd = 0;
            M_Reg2reg = 0;
            M_Wreg = 0;
            #15;
            Clrn = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0, 5'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Latching standard values", test_num);
            reset_dut();

            M_ALUR = 32'hAAAA_BBBB;
            M_Dout = 32'h1234_5678;
            M_Rd   = 5'd15;
            M_Reg2reg = 1'b1;
            M_Wreg = 1'b1;

            @(posedge Clk);
            #2;
            #1;

            check_outputs(32'hAAAA_BBBB, 32'h1234_5678, 5'd15, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Latching different values", test_num);
            reset_dut();

            M_ALUR = 32'h5555_4444;
            M_Dout = 32'h8765_4321;
            M_Rd   = 5'd31;
            M_Reg2reg = 1'b0;
            M_Wreg = 1'b1;

            @(posedge Clk);
            #2;
            #1;

            check_outputs(32'h5555_4444, 32'h8765_4321, 5'd31, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: All bits set", test_num);
            reset_dut();

            M_ALUR = 32'hFFFF_FFFF;
            M_Dout = 32'hFFFF_FFFF;
            M_Rd   = 5'h1F;
            M_Reg2reg = 1'b1;
            M_Wreg = 1'b1;

            @(posedge Clk);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF, 5'h1F, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Asynchronous Reset check", test_num);
            reset_dut();


            M_ALUR = 32'hC0DE_C0DE;
            M_Dout = 32'hBEEF_BEEF;
            M_Rd   = 5'd10;
            M_Reg2reg = 1'b1;
            M_Wreg = 1'b1;

            @(posedge Clk);
            #2;


            Clrn = 0;
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 5'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Data stability check", test_num);
            reset_dut();


            M_ALUR = 32'h1111_1111;
            M_Dout = 32'h2222_2222;
            M_Rd   = 5'd5;
            M_Reg2reg = 1'b0;
            M_Wreg = 1'b1;

            @(posedge Clk);
            #2;


            M_ALUR = 32'h9999_9999;
            M_Dout = 32'h8888_8888;
            #5;


            #1;



            check_outputs(32'h1111_1111, 32'h2222_2222, 5'd5, 1'b0, 1'b1);
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
        input [31:0] expected_W_ALUR;
        input [31:0] expected_W_Dout;
        input [4:0] expected_W_Rd;
        input expected_W_Reg2reg;
        input expected_W_Wreg;
        begin
            if (expected_W_ALUR === (expected_W_ALUR ^ W_ALUR ^ expected_W_ALUR) &&
                expected_W_Dout === (expected_W_Dout ^ W_Dout ^ expected_W_Dout) &&
                expected_W_Rd === (expected_W_Rd ^ W_Rd ^ expected_W_Rd) &&
                expected_W_Reg2reg === (expected_W_Reg2reg ^ W_Reg2reg ^ expected_W_Reg2reg) &&
                expected_W_Wreg === (expected_W_Wreg ^ W_Wreg ^ expected_W_Wreg)) begin
                $display("PASS");
                $display("  Outputs: W_ALUR=%h, W_Dout=%h, W_Rd=%h, W_Reg2reg=%b, W_Wreg=%b",
                         W_ALUR, W_Dout, W_Rd, W_Reg2reg, W_Wreg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: W_ALUR=%h, W_Dout=%h, W_Rd=%h, W_Reg2reg=%b, W_Wreg=%b",
                         expected_W_ALUR, expected_W_Dout, expected_W_Rd, expected_W_Reg2reg, expected_W_Wreg);
                $display("  Got:      W_ALUR=%h, W_Dout=%h, W_Rd=%h, W_Reg2reg=%b, W_Wreg=%b",
                         W_ALUR, W_Dout, W_Rd, W_Reg2reg, W_Wreg);
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
        $dumpvars(0,Clk, Clrn, M_ALUR, M_Dout, M_Rd, M_Reg2reg, M_Wreg, W_ALUR, W_Dout, W_Rd, W_Reg2reg, W_Wreg);
    end

endmodule
