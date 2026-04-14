`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg CE;
    reg CLK;
    reg SCLR;
    wire [15:0] P;
    wire [47:0] PCASC;
    wire [1:0] ZERO_DETECT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CE(CE),
        .CLK(CLK),
        .SCLR(SCLR),
        .P(P),
        .PCASC(PCASC),
        .ZERO_DETECT(ZERO_DETECT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            SCLR = 1;
            CE = 0;
            A = 0;
            B = 0;
            @(posedge CLK);
            #1;
            SCLR = 0;
        end
        endtask
    task step_clk;

        begin
            @(posedge CLK);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            A = 8'd12; B = 8'd10; CE = 1;
            step_clk();

            #1;


            check_outputs(16'h0078, 48'h000000000078, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 8'd25; B = 8'd0; CE = 1;
            step_clk();

            #1;


            check_outputs(16'h0000, 48'h000000000000, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            A = 8'd5; B = 8'hFF;
            CE = 1;
            step_clk();


            #1;



            check_outputs(16'hFFFB, 48'hFFFFFFFFFFFB, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            A = 8'hFE; B = 8'hFE;
            CE = 1;
            step_clk();

            #1;


            check_outputs(16'h0004, 48'h000000000004, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            A = 8'd10; B = 8'd10; CE = 1;
            step_clk();

            CE = 0; A = 8'd5; B = 8'd5;
            step_clk();

            #1;


            check_outputs(16'h0064, 48'h000000000064, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            A = 8'd10; B = 8'd10; CE = 1; SCLR = 1;
            step_clk();

            #1;


            check_outputs(16'h0000, 48'h000000000000, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            A = 8'h7F; B = 8'h7F;
            CE = 1;
            step_clk();

            #1;


            check_outputs(16'h3F01, 48'h000000003F01, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            A = 8'h80; B = 8'h01;
            CE = 1;
            step_clk();

            #1;


            check_outputs(16'hFF80, 48'hFFFFFFFFFF80, 2'b10);
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
        testcase007();
        testcase008();
        
        
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
        input [15:0] expected_P;
        input [47:0] expected_PCASC;
        input [1:0] expected_ZERO_DETECT;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P) &&
                expected_PCASC === (expected_PCASC ^ PCASC ^ expected_PCASC) &&
                expected_ZERO_DETECT === (expected_ZERO_DETECT ^ ZERO_DETECT ^ expected_ZERO_DETECT)) begin
                $display("PASS");
                $display("  Outputs: P=%h, PCASC=%h, ZERO_DETECT=%h",
                         P, PCASC, ZERO_DETECT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h, PCASC=%h, ZERO_DETECT=%h",
                         expected_P, expected_PCASC, expected_ZERO_DETECT);
                $display("  Got:      P=%h, PCASC=%h, ZERO_DETECT=%h",
                         P, PCASC, ZERO_DETECT);
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
        $dumpvars(0,A, B, CE, CLK, SCLR, P, PCASC, ZERO_DETECT);
    end

endmodule
