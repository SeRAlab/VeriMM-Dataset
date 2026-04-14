`timescale 1ns/1ps

module P16C5x_ALU_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] ALU_Op;
    reg CE;
    reg Clk;
    reg [7:0] DI;
    reg [7:0] KI;
    reg Rst;
    reg WE_PSW;
    wire C;
    wire DC;
    wire [7:0] DO;
    wire [7:0] W;
    wire Z;
    wire Z_Tst;
    wire g;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    P16C5x_ALU dut (
        .ALU_Op(ALU_Op),
        .CE(CE),
        .Clk(Clk),
        .DI(DI),
        .KI(KI),
        .Rst(Rst),
        .WE_PSW(WE_PSW),
        .C(C),
        .DC(DC),
        .DO(DO),
        .W(W),
        .Z(Z),
        .Z_Tst(Z_Tst),
        .g(g)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Rst = 1;
            ALU_Op = 12'h0;
            CE = 0;
            DI = 8'h0;
            KI = 8'h0;
            WE_PSW = 0;
            @(posedge Clk);
            #1 Rst = 0;
            @(posedge Clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Reset State Check", test_num);

            #1;


            check_outputs(0, 0, 8'h00, 8'h00, 0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: MOVLW 0xA5", test_num);
            CE = 1;
            ALU_Op = 12'hCA5;
            KI = 8'hA5;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(0, 0, 8'hA5, 8'hA5, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: ADDWF (0x0F + 0x01)", test_num);

            CE = 1;
            ALU_Op = 12'hC0F; KI = 8'h0F; @(posedge Clk); #1;

            ALU_Op = 12'h1C0; DI = 8'h01; WE_PSW = 1;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(0, 1, 8'h10, 8'h10, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: ADDWF (0xFF + 0x01) -> Carry + Zero", test_num);
            CE = 1;
            ALU_Op = 12'hCFF; KI = 8'hFF; @(posedge Clk); #1;
            ALU_Op = 12'h1C0; DI = 8'h01; WE_PSW = 1;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(1, 1, 8'h00, 8'h00, 1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: SUBWF (0x10 - 0x05)", test_num);
            CE = 1;
            ALU_Op = 12'hC05; KI = 8'h05; @(posedge Clk); #1;
            ALU_Op = 12'h080; DI = 8'h10; WE_PSW = 1;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(1, 1, 8'h0B, 8'h0B, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: SUBWF (0x05 - 0x0A) -> Borrow", test_num);
            CE = 1;
            ALU_Op = 12'hC0A; KI = 8'h0A; @(posedge Clk); #1;
            ALU_Op = 12'h080; DI = 8'h05; WE_PSW = 1;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(0, 0, 8'hFB, 8'hFB, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test %0d: ANDWF (0xAA & 0x55)", test_num);
            CE = 1;
            ALU_Op = 12'hCAA; KI = 8'hAA; @(posedge Clk); #1;
            ALU_Op = 12'h140; DI = 8'h55; WE_PSW = 1;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(0, 0, 8'h00, 8'h00, 1, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            $display("Test %0d: BCF (Clear bit 3 of 0xFF)", test_num);
            CE = 1;
            ALU_Op = 12'h418;
            DI = 8'hFF;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(0, 0, 8'hF7, 8'h00, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            $display("Test %0d: BTFSC (Test bit 4 of 0xEF)", test_num);
            CE = 1;
            ALU_Op = 12'h620;
            DI = 8'hEF;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(0, 0, 8'hEF, 8'h00, 0, 0, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("P16C5x_ALU Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_C;
        input expected_DC;
        input [7:0] expected_DO;
        input [7:0] expected_W;
        input expected_Z;
        input expected_Z_Tst;
        input expected_g;
        begin
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_DC === (expected_DC ^ DC ^ expected_DC) &&
                expected_DO === (expected_DO ^ DO ^ expected_DO) &&
                expected_W === (expected_W ^ W ^ expected_W) &&
                expected_Z === (expected_Z ^ Z ^ expected_Z) &&
                expected_Z_Tst === (expected_Z_Tst ^ Z_Tst ^ expected_Z_Tst) &&
                expected_g === (expected_g ^ g ^ expected_g)) begin
                $display("PASS");
                $display("  Outputs: C=%b, DC=%b, DO=%h, W=%h, Z=%b, Z_Tst=%b, g=%b",
                         C, DC, DO, W, Z, Z_Tst, g);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, DC=%b, DO=%h, W=%h, Z=%b, Z_Tst=%b, g=%b",
                         expected_C, expected_DC, expected_DO, expected_W, expected_Z, expected_Z_Tst, expected_g);
                $display("  Got:      C=%b, DC=%b, DO=%h, W=%h, Z=%b, Z_Tst=%b, g=%b",
                         C, DC, DO, W, Z, Z_Tst, g);
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
        $dumpvars(0,ALU_Op, CE, Clk, DI, KI, Rst, WE_PSW, C, DC, DO, W, Z, Z_Tst, g);
    end

endmodule
