`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] BWD;
    reg DFLOAT;
    reg MEI;
    reg [31:0] SRC1;
    reg [31:0] SRC2;
    reg [1:0] START;
    wire LOAD_LSD1;
    wire LOAD_LSD2;
    wire LOAD_MSD;
    wire [31:0] LSD_1;
    wire [31:0] LSD_2;
    wire [20:0] MSD_1;
    wire [20:0] MSD_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BWD(BWD),
        .DFLOAT(DFLOAT),
        .MEI(MEI),
        .SRC1(SRC1),
        .SRC2(SRC2),
        .START(START),
        .LOAD_LSD1(LOAD_LSD1),
        .LOAD_LSD2(LOAD_LSD2),
        .LOAD_MSD(LOAD_MSD),
        .LSD_1(LSD_1),
        .LSD_2(LSD_2),
        .MSD_1(MSD_1),
        .MSD_2(MSD_2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: MEI=1, START=2'b01 (Load Source 1)", test_num);

            START = 2'b01;
            MEI = 1'b1;
            DFLOAT = 1'b1;
            BWD = 2'b10;
            SRC1 = 32'hA5A5_1234;
            SRC2 = 32'h5A5A_BEEF;







            #1;








            check_outputs(1'b1, 1'b0, 1'b1, 32'hA5A5_1234, 32'h5A5A_BEEF, 21'h151234, 21'h1ABEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: MEI=0, START=2'b10 (Load Source 2)", test_num);

            START = 2'b10;
            MEI = 1'b0;
            DFLOAT = 1'b1;
            BWD = 2'b10;
            SRC1 = 32'hFFFF_FFFF;
            SRC2 = 32'h1234_5678;





            #1;






            check_outputs(1'b0, 1'b1, 1'b1, 32'hFFFF_FFFF, 32'h1234_5678, 21'h0FFFFF, 21'h045678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: BWD=01 (Halfword partial selection)", test_num);

            START = 2'b11;
            MEI = 1'b1;
            DFLOAT = 1'b1;
            BWD = 2'b01;
            SRC1 = 32'h1111_2222;
            SRC2 = 32'h3333_4444;




            #1;





            check_outputs(1'b1, 1'b1, 1'b1, 32'h0000_2222, 32'h0000_4444, 21'h112222, 21'h134444);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: BWD=00 (Byte partial selection)", test_num);

            START = 2'b11;
            MEI = 1'b1;
            DFLOAT = 1'b0;
            BWD = 2'b00;
            SRC1 = 32'h8888_88FF;
            SRC2 = 32'h9999_99AA;



            #1;




            check_outputs(1'b1, 1'b1, 1'b1, 32'h0000_00FF, 32'h0000_00AA, 21'h1888FF, 21'h1999AA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: START=00 (No load check)", test_num);

            START = 2'b00;
            MEI = 1'b0;
            DFLOAT = 1'b1;
            BWD = 2'b10;
            SRC1 = 32'hDEAD_BEEF;
            SRC2 = 32'hBABE_FACE;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 32'hDEAD_BEEF, 32'hBABE_FACE, 21'h0DBEEF, 21'h0EFACE);
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
        input expected_LOAD_LSD1;
        input expected_LOAD_LSD2;
        input expected_LOAD_MSD;
        input [31:0] expected_LSD_1;
        input [31:0] expected_LSD_2;
        input [20:0] expected_MSD_1;
        input [20:0] expected_MSD_2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LOAD_LSD1 === (expected_LOAD_LSD1 ^ LOAD_LSD1 ^ expected_LOAD_LSD1) &&
                expected_LOAD_LSD2 === (expected_LOAD_LSD2 ^ LOAD_LSD2 ^ expected_LOAD_LSD2) &&
                expected_LOAD_MSD === (expected_LOAD_MSD ^ LOAD_MSD ^ expected_LOAD_MSD) &&
                expected_LSD_1 === (expected_LSD_1 ^ LSD_1 ^ expected_LSD_1) &&
                expected_LSD_2 === (expected_LSD_2 ^ LSD_2 ^ expected_LSD_2) &&
                expected_MSD_1 === (expected_MSD_1 ^ MSD_1 ^ expected_MSD_1) &&
                expected_MSD_2 === (expected_MSD_2 ^ MSD_2 ^ expected_MSD_2)) begin
                $display("PASS");
                $display("  Outputs: LOAD_LSD1=%b, LOAD_LSD2=%b, LOAD_MSD=%b, LSD_1=%h, LSD_2=%h, MSD_1=%h, MSD_2=%h",
                         LOAD_LSD1, LOAD_LSD2, LOAD_MSD, LSD_1, LSD_2, MSD_1, MSD_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LOAD_LSD1=%b, LOAD_LSD2=%b, LOAD_MSD=%b, LSD_1=%h, LSD_2=%h, MSD_1=%h, MSD_2=%h",
                         expected_LOAD_LSD1, expected_LOAD_LSD2, expected_LOAD_MSD, expected_LSD_1, expected_LSD_2, expected_MSD_1, expected_MSD_2);
                $display("  Got:      LOAD_LSD1=%b, LOAD_LSD2=%b, LOAD_MSD=%b, LSD_1=%h, LSD_2=%h, MSD_1=%h, MSD_2=%h",
                         LOAD_LSD1, LOAD_LSD2, LOAD_MSD, LSD_1, LSD_2, MSD_1, MSD_2);
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

endmodule
