`timescale 1ns/1ps

module aeMB_regf_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] dwb_dat_i;
    reg [31:0] fsl_dat_i;
    reg gclk;
    reg gena;
    reg grst;
    reg rBRA;
    reg rDLY;
    reg [3:0] rDWBSEL;
    reg [1:0] rMXDST;
    reg [5:0] rOPC;
    reg [29:0] rPCLNK;
    reg [4:0] rRA;
    reg [4:0] rRB;
    reg [4:0] rRD;
    reg [31:0] rRESULT;
    reg [4:0] rRW;
    wire [31:0] dwb_dat_o;
    wire [31:0] fsl_dat_o;
    wire [31:0] rDWBDI;
    wire [31:0] rREGA;
    wire [31:0] rREGB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aeMB_regf dut (
        .dwb_dat_i(dwb_dat_i),
        .fsl_dat_i(fsl_dat_i),
        .gclk(gclk),
        .gena(gena),
        .grst(grst),
        .rBRA(rBRA),
        .rDLY(rDLY),
        .rDWBSEL(rDWBSEL),
        .rMXDST(rMXDST),
        .rOPC(rOPC),
        .rPCLNK(rPCLNK),
        .rRA(rRA),
        .rRB(rRB),
        .rRD(rRD),
        .rRESULT(rRESULT),
        .rRW(rRW),
        .dwb_dat_o(dwb_dat_o),
        .fsl_dat_o(fsl_dat_o),
        .rDWBDI(rDWBDI),
        .rREGA(rREGA),
        .rREGB(rREGB)
    );

    // Clock generation (10ns period)
    initial begin
        gclk = 0;
        forever #5 gclk = ~gclk;
    end

        task reset_dut;

        begin
            grst = 1;
            gena = 0;
            dwb_dat_i = 0;
            fsl_dat_i = 0;
            rBRA = 0;
            rDLY = 0;
            rDWBSEL = 4'b1111;
            rMXDST = 2'b00;
            rOPC = 6'b000000;
            rPCLNK = 30'h0;
            rRA = 5'd0;
            rRB = 5'd0;
            rRD = 5'd0;
            rRESULT = 32'h0;
            rRW = 5'd0;
            @(posedge gclk);
            #1;
            grst = 0;
            @(posedge gclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write/Read ALU Result", test_num);
            reset_dut();


            @(negedge gclk);
            gena = 1;
            rRW = 5'd5;
            rMXDST = 2'b00;
            rRESULT = 32'hDEADBEEF;

            @(negedge gclk);
            gena = 0;


            rRA = 5'd5;
            rRB = 5'd5;

            @(posedge gclk);
            #2;

            #1;


            check_outputs(32'hDEADBEEF, 32'hDEADBEEF, 32'h0, 32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Register 0 Constant Zero", test_num);
            reset_dut();

            @(negedge gclk);
            gena = 1;
            rRW = 5'd0;
            rMXDST = 2'b00;
            rRESULT = 32'hFFFFFFFF;

            @(negedge gclk);
            gena = 0;
            rRA = 5'd0;
            rRB = 5'd0;

            @(posedge gclk);
            #2;
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Internal Forwarding Logic", test_num);
            reset_dut();

            @(negedge gclk);
            gena = 1;
            rRW = 5'd10;
            rRA = 5'd10;
            rRB = 5'd10;
            rMXDST = 2'b00;
            rRESULT = 32'h12345678;

            @(posedge gclk);
            #2;

            #1;


            check_outputs(32'h12345678, 32'h12345678, 32'h0, 32'h12345678, 32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: FSL Data Interface", test_num);
            reset_dut();

            @(negedge gclk);
            gena = 1;
            rRW = 5'd20;
            rMXDST = 2'b11;
            fsl_dat_i = 32'hAABBCCDD;

            @(negedge gclk);
            gena = 0;
            rRA = 5'd20;
            rRB = 5'd20;

            @(posedge gclk);
            #2;
            #1;

            check_outputs(32'hAABBCCDD, 32'hAABBCCDD, 32'h0, 32'hAABBCCDD, 32'hAABBCCDD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: PC Link Selection", test_num);
            reset_dut();

            @(negedge gclk);
            gena = 1;
            rRW = 5'd31;
            rMXDST = 2'b01;
            rPCLNK = 30'h0AAAAAAA;

            @(negedge gclk);
            gena = 0;
            rRA = 5'd31;

            @(posedge gclk);
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0, 32'h2AAAAAA8, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: DWB Masking and Loading", test_num);
            reset_dut();

            @(negedge gclk);
            gena = 1;
            rRW = 5'd15;
            rMXDST = 2'b10;
            dwb_dat_i = 32'h11223344;
            rDWBSEL = 4'b1111;

            @(negedge gclk);
            gena = 0;
            rRA = 5'd15;

            @(posedge gclk);
            #2;

            #1;


            check_outputs(32'h0, 32'h0, 32'h11223344, 32'h11223344, 32'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Source Reads", test_num);
            reset_dut();


            @(negedge gclk);
            gena = 1; rRW = 5'd1; rMXDST = 2'b00; rRESULT = 32'h11111111;

            @(negedge gclk);
            gena = 1; rRW = 5'd2; rMXDST = 2'b00; rRESULT = 32'h22222222;

            @(negedge gclk);
            gena = 0;
            rRA = 5'd1;
            rRB = 5'd2;

            @(posedge gclk);
            #2;
            #1;

            check_outputs(32'h22222222, 32'h22222222, 32'h0, 32'h11111111, 32'h22222222);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aeMB_regf Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [31:0] expected_dwb_dat_o;
        input [31:0] expected_fsl_dat_o;
        input [31:0] expected_rDWBDI;
        input [31:0] expected_rREGA;
        input [31:0] expected_rREGB;
        begin
            if (expected_dwb_dat_o === (expected_dwb_dat_o ^ dwb_dat_o ^ expected_dwb_dat_o) &&
                expected_fsl_dat_o === (expected_fsl_dat_o ^ fsl_dat_o ^ expected_fsl_dat_o) &&
                expected_rDWBDI === (expected_rDWBDI ^ rDWBDI ^ expected_rDWBDI) &&
                expected_rREGA === (expected_rREGA ^ rREGA ^ expected_rREGA) &&
                expected_rREGB === (expected_rREGB ^ rREGB ^ expected_rREGB)) begin
                $display("PASS");
                $display("  Outputs: dwb_dat_o=%h, fsl_dat_o=%h, rDWBDI=%h, rREGA=%h, rREGB=%h",
                         dwb_dat_o, fsl_dat_o, rDWBDI, rREGA, rREGB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dwb_dat_o=%h, fsl_dat_o=%h, rDWBDI=%h, rREGA=%h, rREGB=%h",
                         expected_dwb_dat_o, expected_fsl_dat_o, expected_rDWBDI, expected_rREGA, expected_rREGB);
                $display("  Got:      dwb_dat_o=%h, fsl_dat_o=%h, rDWBDI=%h, rREGA=%h, rREGB=%h",
                         dwb_dat_o, fsl_dat_o, rDWBDI, rREGA, rREGB);
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
        $dumpvars(0,dwb_dat_i, fsl_dat_i, gclk, gena, grst, rBRA, rDLY, rDWBSEL, rMXDST, rOPC, rPCLNK, rRA, rRB, rRD, rRESULT, rRW, dwb_dat_o, fsl_dat_o, rDWBDI, rREGA, rREGB);
    end

endmodule
