`timescale 1ns/1ps

module VGA_Ctrl_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] iBlue;
    reg iCLK;
    reg [9:0] iGreen;
    reg iRST_N;
    reg [9:0] iRed;
    reg les_btn;
    wire [10:0] oCurrent_X;
    wire [10:0] oCurrent_Y;
    wire [9:0] oVGA_B;
    wire oVGA_BLANK;
    wire oVGA_CLOCK;
    wire [9:0] oVGA_G;
    wire oVGA_HS;
    wire [9:0] oVGA_R;
    wire oVGA_SYNC;
    wire oVGA_VS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VGA_Ctrl dut (
        .iBlue(iBlue),
        .iCLK(iCLK),
        .iGreen(iGreen),
        .iRST_N(iRST_N),
        .iRed(iRed),
        .les_btn(les_btn),
        .oCurrent_X(oCurrent_X),
        .oCurrent_Y(oCurrent_Y),
        .oVGA_B(oVGA_B),
        .oVGA_BLANK(oVGA_BLANK),
        .oVGA_CLOCK(oVGA_CLOCK),
        .oVGA_G(oVGA_G),
        .oVGA_HS(oVGA_HS),
        .oVGA_R(oVGA_R),
        .oVGA_SYNC(oVGA_SYNC),
        .oVGA_VS(oVGA_VS)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

        begin
            iRST_N = 0;
            iRed = 0; iGreen = 0; iBlue = 0; les_btn = 0;
            repeat(2) @(posedge iCLK);
            #2 iRST_N = 1;
            repeat(1) @(posedge iCLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(11'h0, 11'h0, 10'h0, 1'b0, 1'b1, 10'h0, 1'b0, 10'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            repeat(50) @(posedge iCLK);
            #2;

            #1;


            check_outputs(11'h0, 11'h0, 10'h0, 1'b0, 1'b1, 10'h0, 1'b0, 10'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(100) @(posedge iCLK);
            #2;

            #1;


            check_outputs(11'h0, 11'h0, 10'h0, 1'b0, 1'b1, 10'h0, 1'b1, 10'h0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            iRed = 10'h3FF; iGreen = 10'h123; iBlue = 10'h0AA;


            repeat(35*800 + 144) @(posedge iCLK);
            #2;



            #1;




            check_outputs(11'h1, 11'h0, 10'h0AA, 1'b1, 1'b1, 10'h123, 1'b1, 10'h3FF, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            iRed = 10'h200;
            repeat(35*800 + 144 + 639) @(posedge iCLK);
            #2;

            #1;


            check_outputs(11'h0, 11'h0, 10'h0, 1'b0, 1'b1, 10'h0, 1'b1, 10'h0, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VGA_Ctrl Testbench");
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
        input [10:0] expected_oCurrent_X;
        input [10:0] expected_oCurrent_Y;
        input [9:0] expected_oVGA_B;
        input expected_oVGA_BLANK;
        input expected_oVGA_CLOCK;
        input [9:0] expected_oVGA_G;
        input expected_oVGA_HS;
        input [9:0] expected_oVGA_R;
        input expected_oVGA_SYNC;
        input expected_oVGA_VS;
        begin
            if (expected_oCurrent_X === (expected_oCurrent_X ^ oCurrent_X ^ expected_oCurrent_X) &&
                expected_oCurrent_Y === (expected_oCurrent_Y ^ oCurrent_Y ^ expected_oCurrent_Y) &&
                expected_oVGA_B === (expected_oVGA_B ^ oVGA_B ^ expected_oVGA_B) &&
                expected_oVGA_BLANK === (expected_oVGA_BLANK ^ oVGA_BLANK ^ expected_oVGA_BLANK) &&
                expected_oVGA_CLOCK === (expected_oVGA_CLOCK ^ oVGA_CLOCK ^ expected_oVGA_CLOCK) &&
                expected_oVGA_G === (expected_oVGA_G ^ oVGA_G ^ expected_oVGA_G) &&
                expected_oVGA_HS === (expected_oVGA_HS ^ oVGA_HS ^ expected_oVGA_HS) &&
                expected_oVGA_R === (expected_oVGA_R ^ oVGA_R ^ expected_oVGA_R) &&
                expected_oVGA_SYNC === (expected_oVGA_SYNC ^ oVGA_SYNC ^ expected_oVGA_SYNC) &&
                expected_oVGA_VS === (expected_oVGA_VS ^ oVGA_VS ^ expected_oVGA_VS)) begin
                $display("PASS");
                $display("  Outputs: oCurrent_X=%h, oCurrent_Y=%h, oVGA_B=%h, oVGA_BLANK=%b, oVGA_CLOCK=%b, oVGA_G=%h, oVGA_HS=%b, oVGA_R=%h, oVGA_SYNC=%b, oVGA_VS=%b",
                         oCurrent_X, oCurrent_Y, oVGA_B, oVGA_BLANK, oVGA_CLOCK, oVGA_G, oVGA_HS, oVGA_R, oVGA_SYNC, oVGA_VS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oCurrent_X=%h, oCurrent_Y=%h, oVGA_B=%h, oVGA_BLANK=%b, oVGA_CLOCK=%b, oVGA_G=%h, oVGA_HS=%b, oVGA_R=%h, oVGA_SYNC=%b, oVGA_VS=%b",
                         expected_oCurrent_X, expected_oCurrent_Y, expected_oVGA_B, expected_oVGA_BLANK, expected_oVGA_CLOCK, expected_oVGA_G, expected_oVGA_HS, expected_oVGA_R, expected_oVGA_SYNC, expected_oVGA_VS);
                $display("  Got:      oCurrent_X=%h, oCurrent_Y=%h, oVGA_B=%h, oVGA_BLANK=%b, oVGA_CLOCK=%b, oVGA_G=%h, oVGA_HS=%b, oVGA_R=%h, oVGA_SYNC=%b, oVGA_VS=%b",
                         oCurrent_X, oCurrent_Y, oVGA_B, oVGA_BLANK, oVGA_CLOCK, oVGA_G, oVGA_HS, oVGA_R, oVGA_SYNC, oVGA_VS);
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
        $dumpvars(0,iBlue, iCLK, iGreen, iRST_N, iRed, les_btn, oCurrent_X, oCurrent_Y, oVGA_B, oVGA_BLANK, oVGA_CLOCK, oVGA_G, oVGA_HS, oVGA_R, oVGA_SYNC, oVGA_VS);
    end

endmodule
