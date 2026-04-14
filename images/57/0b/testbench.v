`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] aluc;
    reg [1:0] aluimm;
    reg clk;
    reg [31:0] extend;
    reg [1:0] m2reg;
    reg [4:0] mux;
    reg [31:0] qa;
    reg [31:0] qb;
    reg [1:0] wmem;
    reg [1:0] wreg;
    wire [3:0] ealuc;
    wire [1:0] ealuimm;
    wire [31:0] eextend;
    wire [1:0] em2reg;
    wire [4:0] emux;
    wire [31:0] eqa;
    wire [31:0] eqb;
    wire [1:0] ewmem;
    wire [1:0] ewreg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluc(aluc),
        .aluimm(aluimm),
        .clk(clk),
        .extend(extend),
        .m2reg(m2reg),
        .mux(mux),
        .qa(qa),
        .qb(qb),
        .wmem(wmem),
        .wreg(wreg),
        .ealuc(ealuc),
        .ealuimm(ealuimm),
        .eextend(eextend),
        .em2reg(em2reg),
        .emux(emux),
        .eqa(eqa),
        .eqb(eqb),
        .ewmem(ewmem),
        .ewreg(ewreg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin



            aluc    = 4'd0;
            aluimm  = 2'd0;
            extend  = 32'd0;
            m2reg   = 2'd0;
            mux     = 5'd0;
            qa      = 32'd0;
            qb      = 32'd0;
            wmem    = 2'd0;
            wreg    = 2'd0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Pass-through (ADD Operation Pattern)", test_num);
            reset_dut();


            aluc    = 4'b0010;
            aluimm  = 2'b01;
            extend  = 32'h0000_1234;
            m2reg   = 2'b00;
            mux     = 5'd15;
            qa      = 32'hAAAA_AAAA;
            qb      = 32'h5555_5555;
            wmem    = 2'b00;
            wreg    = 2'b01;

            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0010, 2'b01, 32'h0000_1234, 2'b00, 5'd15, 32'hAAAA_AAAA, 32'h5555_5555, 2'b00, 2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High-bit signals and Store Pattern", test_num);
            reset_dut();


            aluc    = 4'b1111;
            aluimm  = 2'b11;
            extend  = 32'hFFFF_FFFF;
            m2reg   = 2'b10;
            mux     = 5'd31;
            qa      = 32'h1234_5678;
            qb      = 32'h8765_4321;
            wmem    = 2'b01;
            wreg    = 2'b00;

            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1111, 2'b11, 32'hFFFF_FFFF, 2'b10, 5'd31, 32'h1234_5678, 32'h8765_4321, 2'b01, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Values check", test_num);
            reset_dut();


            aluc    = 4'h0;
            aluimm  = 2'h0;
            extend  = 32'h0;
            m2reg   = 2'h0;
            mux     = 5'h0;
            qa      = 32'h0;
            qb      = 32'h0;
            wmem    = 2'h0;
            wreg    = 2'h0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h0, 2'h0, 32'h0, 2'h0, 5'h0, 32'h0, 32'h0, 2'h0, 2'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit patterns", test_num);
            reset_dut();

            aluc    = 4'b1010;
            aluimm  = 2'b01;
            extend  = 32'h5A5A_5A5A;
            m2reg   = 2'b10;
            mux     = 5'b10101;
            qa      = 32'hC3C3_C3C3;
            qb      = 32'h3C3C_3C3C;
            wmem    = 2'b10;
            wreg    = 2'b01;

            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1010, 2'b01, 32'h5A5A_5A5A, 2'b10, 5'b10101, 32'hC3C3_C3C3, 32'h3C3C_3C3C, 2'b10, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify pipeline hold property", test_num);
            reset_dut();


            aluc    = 4'hE;
            qa      = 32'hDEADC0DE;
            @(posedge clk);
            #1;


            aluc    = 4'h0;
            qa      = 32'h00000000;


            #1;



            check_outputs(4'hE, 2'h0, 32'h0, 2'h0, 5'h0, 32'hDEADC0DE, 32'h0, 2'h0, 2'h0);
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
        input [3:0] expected_ealuc;
        input [1:0] expected_ealuimm;
        input [31:0] expected_eextend;
        input [1:0] expected_em2reg;
        input [4:0] expected_emux;
        input [31:0] expected_eqa;
        input [31:0] expected_eqb;
        input [1:0] expected_ewmem;
        input [1:0] expected_ewreg;
        begin
            if (expected_ealuc === (expected_ealuc ^ ealuc ^ expected_ealuc) &&
                expected_ealuimm === (expected_ealuimm ^ ealuimm ^ expected_ealuimm) &&
                expected_eextend === (expected_eextend ^ eextend ^ expected_eextend) &&
                expected_em2reg === (expected_em2reg ^ em2reg ^ expected_em2reg) &&
                expected_emux === (expected_emux ^ emux ^ expected_emux) &&
                expected_eqa === (expected_eqa ^ eqa ^ expected_eqa) &&
                expected_eqb === (expected_eqb ^ eqb ^ expected_eqb) &&
                expected_ewmem === (expected_ewmem ^ ewmem ^ expected_ewmem) &&
                expected_ewreg === (expected_ewreg ^ ewreg ^ expected_ewreg)) begin
                $display("PASS");
                $display("  Outputs: ealuc=%h, ealuimm=%h, eextend=%h, em2reg=%h, emux=%h, eqa=%h, eqb=%h, ewmem=%h, ewreg=%h",
                         ealuc, ealuimm, eextend, em2reg, emux, eqa, eqb, ewmem, ewreg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ealuc=%h, ealuimm=%h, eextend=%h, em2reg=%h, emux=%h, eqa=%h, eqb=%h, ewmem=%h, ewreg=%h",
                         expected_ealuc, expected_ealuimm, expected_eextend, expected_em2reg, expected_emux, expected_eqa, expected_eqb, expected_ewmem, expected_ewreg);
                $display("  Got:      ealuc=%h, ealuimm=%h, eextend=%h, em2reg=%h, emux=%h, eqa=%h, eqb=%h, ewmem=%h, ewreg=%h",
                         ealuc, ealuimm, eextend, em2reg, emux, eqa, eqb, ewmem, ewreg);
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
        $dumpvars(0,aluc, aluimm, clk, extend, m2reg, mux, qa, qb, wmem, wreg, ealuc, ealuimm, eextend, em2reg, emux, eqa, eqb, ewmem, ewreg);
    end

endmodule
