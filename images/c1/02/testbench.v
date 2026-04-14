`timescale 1ns/1ps

module aeMB_ibuf_tb;

    // Testbench signals (sequential circuit)
    reg gclk;
    reg gena;
    reg grst;
    reg iwb_ack_i;
    reg [31:0] iwb_dat_i;
    reg oena;
    reg rBRA;
    reg rMSR_BIP;
    reg rMSR_IE;
    reg sys_int_i;
    wire iwb_stb_o;
    wire [10:0] rALT;
    wire [15:0] rIMM;
    wire [5:0] rOPC;
    wire [4:0] rRA;
    wire [4:0] rRB;
    wire [4:0] rRD;
    wire [31:0] rSIMM;
    wire rSTALL;
    wire [31:0] xIREG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aeMB_ibuf dut (
        .gclk(gclk),
        .gena(gena),
        .grst(grst),
        .iwb_ack_i(iwb_ack_i),
        .iwb_dat_i(iwb_dat_i),
        .oena(oena),
        .rBRA(rBRA),
        .rMSR_BIP(rMSR_BIP),
        .rMSR_IE(rMSR_IE),
        .sys_int_i(sys_int_i),
        .iwb_stb_o(iwb_stb_o),
        .rALT(rALT),
        .rIMM(rIMM),
        .rOPC(rOPC),
        .rRA(rRA),
        .rRB(rRB),
        .rRD(rRD),
        .rSIMM(rSIMM),
        .rSTALL(rSTALL),
        .xIREG(xIREG)
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
            oena = 0;
            iwb_ack_i = 0;
            iwb_dat_i = 0;
            rBRA = 0;
            rMSR_IE = 0;
            rMSR_BIP = 0;
            sys_int_i = 0;
            repeat(2) @(posedge gclk);
            #1 grst = 0;
            repeat(1) @(posedge gclk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            gena = 1;
            oena = 1;


            iwb_dat_i = 32'h12345678;
            iwb_ack_i = 1;
            @(posedge gclk);
            #2;
            #1;

            check_outputs(1, 11'h678, 16'h5678, 6'h04, 5'h11, 5'h0A, 5'h11, 32'h00005678, 0, 32'h12345678);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            gena = 1;
            oena = 1;


            iwb_dat_i = 32'h8C22ABCD;
            iwb_ack_i = 1;
            @(posedge gclk);
            #2;
            #1;

            check_outputs(1, 11'h3CD, 16'hABCD, 6'h23, 5'h02, 5'h05, 5'h01, 32'hFFFFABCD, 0, 32'h8C22ABCD);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            gena = 1;
            oena = 1;
            iwb_ack_i = 0;
            @(posedge gclk);
            #2;

            if (iwb_stb_o == 1) pass_count = pass_count + 1;
            else fail_count = fail_count + 1;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            gena = 0;
            oena = 1;
            iwb_dat_i = 32'hFFFFFFFF;
            iwb_ack_i = 1;
            @(posedge gclk);
            #2;

            #1;


            check_outputs(1, 11'h0, 16'h0, 6'h0, 5'h0, 5'h0, 5'h0, 32'h0, 0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            gena = 1;
            oena = 1;
            rBRA = 1;
            iwb_dat_i = 32'h11112222;
            iwb_ack_i = 1;
            @(posedge gclk);
            #2;

            if (iwb_stb_o == 1) pass_count = pass_count + 1;
            else fail_count = fail_count + 1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aeMB_ibuf Testbench");
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
        input expected_iwb_stb_o;
        input [10:0] expected_rALT;
        input [15:0] expected_rIMM;
        input [5:0] expected_rOPC;
        input [4:0] expected_rRA;
        input [4:0] expected_rRB;
        input [4:0] expected_rRD;
        input [31:0] expected_rSIMM;
        input expected_rSTALL;
        input [31:0] expected_xIREG;
        begin
            if (expected_iwb_stb_o === (expected_iwb_stb_o ^ iwb_stb_o ^ expected_iwb_stb_o) &&
                expected_rALT === (expected_rALT ^ rALT ^ expected_rALT) &&
                expected_rIMM === (expected_rIMM ^ rIMM ^ expected_rIMM) &&
                expected_rOPC === (expected_rOPC ^ rOPC ^ expected_rOPC) &&
                expected_rRA === (expected_rRA ^ rRA ^ expected_rRA) &&
                expected_rRB === (expected_rRB ^ rRB ^ expected_rRB) &&
                expected_rRD === (expected_rRD ^ rRD ^ expected_rRD) &&
                expected_rSIMM === (expected_rSIMM ^ rSIMM ^ expected_rSIMM) &&
                expected_rSTALL === (expected_rSTALL ^ rSTALL ^ expected_rSTALL) &&
                expected_xIREG === (expected_xIREG ^ xIREG ^ expected_xIREG)) begin
                $display("PASS");
                $display("  Outputs: iwb_stb_o=%b, rALT=%h, rIMM=%h, rOPC=%h, rRA=%h, rRB=%h, rRD=%h, rSIMM=%h, rSTALL=%b, xIREG=%h",
                         iwb_stb_o, rALT, rIMM, rOPC, rRA, rRB, rRD, rSIMM, rSTALL, xIREG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: iwb_stb_o=%b, rALT=%h, rIMM=%h, rOPC=%h, rRA=%h, rRB=%h, rRD=%h, rSIMM=%h, rSTALL=%b, xIREG=%h",
                         expected_iwb_stb_o, expected_rALT, expected_rIMM, expected_rOPC, expected_rRA, expected_rRB, expected_rRD, expected_rSIMM, expected_rSTALL, expected_xIREG);
                $display("  Got:      iwb_stb_o=%b, rALT=%h, rIMM=%h, rOPC=%h, rRA=%h, rRB=%h, rRD=%h, rSIMM=%h, rSTALL=%b, xIREG=%h",
                         iwb_stb_o, rALT, rIMM, rOPC, rRA, rRB, rRD, rSIMM, rSTALL, xIREG);
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
        $dumpvars(0,gclk, gena, grst, iwb_ack_i, iwb_dat_i, oena, rBRA, rMSR_BIP, rMSR_IE, sys_int_i, iwb_stb_o, rALT, rIMM, rOPC, rRA, rRB, rRD, rSIMM, rSTALL, xIREG);
    end

endmodule
