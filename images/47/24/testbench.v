`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] DADDR_IN;
    reg DCLK_IN;
    reg DEN_IN;
    reg [15:0] DI_IN;
    reg DWE_IN;
    reg VAUXN12;
    reg VAUXN13;
    reg VAUXP12;
    reg VAUXP13;
    reg VN_IN;
    reg VP_IN;
    wire ALARM_OUT;
    wire [15:0] DO_OUT;
    wire DRDY_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DADDR_IN(DADDR_IN),
        .DCLK_IN(DCLK_IN),
        .DEN_IN(DEN_IN),
        .DI_IN(DI_IN),
        .DWE_IN(DWE_IN),
        .VAUXN12(VAUXN12),
        .VAUXN13(VAUXN13),
        .VAUXP12(VAUXP12),
        .VAUXP13(VAUXP13),
        .VN_IN(VN_IN),
        .VP_IN(VP_IN),
        .ALARM_OUT(ALARM_OUT),
        .DO_OUT(DO_OUT),
        .DRDY_OUT(DRDY_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        DCLK_IN = 0;
        forever #5 DCLK_IN = ~DCLK_IN;
    end

        task reset_dut;

        begin
            DADDR_IN = 7'h0;
            DEN_IN = 1'b0;
            DI_IN = 16'h0;
            DWE_IN = 1'b0;
            VAUXN12 = 1'b0;
            VAUXN13 = 1'b0;
            VAUXP12 = 1'b0;
            VAUXP13 = 1'b0;
            VN_IN = 1'b0;
            VP_IN = 1'b0;
            repeat(5) @(posedge DCLK_IN);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(posedge DCLK_IN);
            DADDR_IN = 7'h40;
            DI_IN = 16'h9ABC;
            DWE_IN = 1'b1;
            DEN_IN = 1'b1;

            @(posedge DCLK_IN);
            DEN_IN = 1'b0;
            DWE_IN = 1'b0;


            while (!DRDY_OUT) @(posedge DCLK_IN);



            #1;




            check_outputs(ALARM_OUT, DO_OUT, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            @(posedge DCLK_IN);
            DADDR_IN = 7'h40;
            DWE_IN = 1'b0;
            DEN_IN = 1'b1;

            @(posedge DCLK_IN);
            DEN_IN = 1'b0;


            while (!DRDY_OUT) @(posedge DCLK_IN);



            #1;




            check_outputs(ALARM_OUT, DO_OUT, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            DADDR_IN = 7'h10;
            DI_IN = 16'hFFFF;
            DWE_IN = 1'b1;
            DEN_IN = 1'b0;

            repeat(10) @(posedge DCLK_IN);


            #1;



            check_outputs(ALARM_OUT, DO_OUT, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            VAUXP12 = 1'b1;
            VAUXN12 = 1'b0;

            @(posedge DCLK_IN);
            DADDR_IN = 7'h1C;
            DWE_IN = 1'b0;
            DEN_IN = 1'b1;

            @(posedge DCLK_IN);
            DEN_IN = 1'b0;


            while (!DRDY_OUT) @(posedge DCLK_IN);


            #1;



            check_outputs(ALARM_OUT, DO_OUT, 1'b1);
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
        input expected_ALARM_OUT;
        input [15:0] expected_DO_OUT;
        input expected_DRDY_OUT;
        begin
            if (expected_ALARM_OUT === (expected_ALARM_OUT ^ ALARM_OUT ^ expected_ALARM_OUT) &&
                expected_DO_OUT === (expected_DO_OUT ^ DO_OUT ^ expected_DO_OUT) &&
                expected_DRDY_OUT === (expected_DRDY_OUT ^ DRDY_OUT ^ expected_DRDY_OUT)) begin
                $display("PASS");
                $display("  Outputs: ALARM_OUT=%b, DO_OUT=%h, DRDY_OUT=%b",
                         ALARM_OUT, DO_OUT, DRDY_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALARM_OUT=%b, DO_OUT=%h, DRDY_OUT=%b",
                         expected_ALARM_OUT, expected_DO_OUT, expected_DRDY_OUT);
                $display("  Got:      ALARM_OUT=%b, DO_OUT=%h, DRDY_OUT=%b",
                         ALARM_OUT, DO_OUT, DRDY_OUT);
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
        $dumpvars(0,DADDR_IN, DCLK_IN, DEN_IN, DI_IN, DWE_IN, VAUXN12, VAUXN13, VAUXP12, VAUXP13, VN_IN, VP_IN, ALARM_OUT, DO_OUT, DRDY_OUT);
    end

endmodule
