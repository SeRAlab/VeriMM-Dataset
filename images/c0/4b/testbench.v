`timescale 1ns/1ps

module aeMB_bpcu_tb;

    // Testbench signals (sequential circuit)
    reg gclk;
    reg gena;
    reg grst;
    reg [31:0] rDWBDI;
    reg [1:0] rMXALT;
    reg [5:0] rOPC;
    reg [4:0] rRA;
    reg [4:0] rRD;
    reg [31:0] rREGA;
    reg [31:0] rRESULT;
    wire [21:0] iwb_adr_o;
    wire rBRA;
    wire rDLY;
    wire [29:0] rPC;
    wire [29:0] rPCLNK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aeMB_bpcu dut (
        .gclk(gclk),
        .gena(gena),
        .grst(grst),
        .rDWBDI(rDWBDI),
        .rMXALT(rMXALT),
        .rOPC(rOPC),
        .rRA(rRA),
        .rRD(rRD),
        .rREGA(rREGA),
        .rRESULT(rRESULT),
        .iwb_adr_o(iwb_adr_o),
        .rBRA(rBRA),
        .rDLY(rDLY),
        .rPC(rPC),
        .rPCLNK(rPCLNK)
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
            rDWBDI = 0;
            rMXALT = 0;
            rOPC = 0;
            rRA = 0;
            rRD = 0;
            rREGA = 0;
            rRESULT = 0;
            @(posedge gclk);
            #2 grst = 0;
            gena = 1;
            @(posedge gclk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase %03d: System Reset", test_num);
            reset_dut();

            #1;


            check_outputs(22'h0, 1'b0, 1'b0, 30'h0, 30'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase %03d: Sequential PC Increment", test_num);
            reset_dut();
            rOPC = 6'b000000;
            @(posedge gclk); #2;
            @(posedge gclk); #2;
            #1;

            check_outputs(22'h2, 1'b0, 1'b0, 30'h2, 30'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase %03d: Unconditional Branch", test_num);
            reset_dut();

            rOPC = 6'h26;
            rMXALT = 2'b01;
            rRESULT = 32'h0000_0100;
            @(posedge gclk); #2;


            #1;



            check_outputs(22'h40, 1'b1, 1'b1, 30'h40, 30'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase %03d: Conditional Branch (Taken)", test_num);
            reset_dut();
            rOPC = 6'h2E;
            rRA = 5'd1;
            rREGA = 32'h0;
            rMXALT = 2'b01;
            rRESULT = 32'h0000_0200;
            @(posedge gclk); #2;
            #1;

            check_outputs(22'h80, 1'b1, 1'b1, 30'h80, 30'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase %03d: Conditional Branch (Not Taken)", test_num);
            reset_dut();
            rOPC = 6'h2E;
            rRD = 5'b00001;
            rRA = 5'd1;
            rREGA = 32'hFFFF_FFFF;
            rMXALT = 2'b01;
            rRESULT = 32'h0000_0300;
            @(posedge gclk); #2;

            #1;


            check_outputs(22'h1, 1'b0, 1'b0, 30'h1, 30'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nRunning Testcase %03d: Branch and Link", test_num);
            reset_dut();
            rOPC = 6'h27;
            rMXALT = 2'b10;
            rREGA = 32'h0000_0400;
            @(posedge gclk); #2;

            #1;


            check_outputs(22'h100, 1'b1, 1'b1, 30'h100, 30'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nRunning Testcase %03d: Global Enable Toggle", test_num);
            reset_dut();
            gena = 1;
            @(posedge gclk); #2;
            gena = 0;
            @(posedge gclk); #2;
            @(posedge gclk); #2;
            #1;

            check_outputs(22'h1, 1'b0, 1'b0, 30'h1, 30'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aeMB_bpcu Testbench");
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
        input [21:0] expected_iwb_adr_o;
        input expected_rBRA;
        input expected_rDLY;
        input [29:0] expected_rPC;
        input [29:0] expected_rPCLNK;
        begin
            if (expected_iwb_adr_o === (expected_iwb_adr_o ^ iwb_adr_o ^ expected_iwb_adr_o) &&
                expected_rBRA === (expected_rBRA ^ rBRA ^ expected_rBRA) &&
                expected_rDLY === (expected_rDLY ^ rDLY ^ expected_rDLY) &&
                expected_rPC === (expected_rPC ^ rPC ^ expected_rPC) &&
                expected_rPCLNK === (expected_rPCLNK ^ rPCLNK ^ expected_rPCLNK)) begin
                $display("PASS");
                $display("  Outputs: iwb_adr_o=%h, rBRA=%b, rDLY=%b, rPC=%h, rPCLNK=%h",
                         iwb_adr_o, rBRA, rDLY, rPC, rPCLNK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: iwb_adr_o=%h, rBRA=%b, rDLY=%b, rPC=%h, rPCLNK=%h",
                         expected_iwb_adr_o, expected_rBRA, expected_rDLY, expected_rPC, expected_rPCLNK);
                $display("  Got:      iwb_adr_o=%h, rBRA=%b, rDLY=%b, rPC=%h, rPCLNK=%h",
                         iwb_adr_o, rBRA, rDLY, rPC, rPCLNK);
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
        $dumpvars(0,gclk, gena, grst, rDWBDI, rMXALT, rOPC, rRA, rRD, rREGA, rRESULT, iwb_adr_o, rBRA, rDLY, rPC, rPCLNK);
    end

endmodule
