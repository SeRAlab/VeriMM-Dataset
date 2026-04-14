`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg IRQ;
    reg [31:0] PrAddr;
    reg [31:0] PrWD;
    reg [31:0] rd1;
    reg [31:0] rd2;
    reg [31:0] rd3;
    reg wen;
    wire [5:0] HWInt;
    wire [31:0] PrRD;
    wire outwe;
    wire twe;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IRQ(IRQ),
        .PrAddr(PrAddr),
        .PrWD(PrWD),
        .rd1(rd1),
        .rd2(rd2),
        .rd3(rd3),
        .wen(wen),
        .HWInt(HWInt),
        .PrRD(PrRD),
        .outwe(outwe),
        .twe(twe)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Read from Timer Range (0x7F00)", test_num);
            IRQ = 0;
            PrAddr = 32'h0000_7F00;
            PrWD = 32'h0;
            rd1 = 32'hAAAA_5555;
            rd2 = 32'h1234_5678;
            rd3 = 32'hDEAD_BEEF;
            wen = 0;

            #1;


            check_outputs(6'b000000, 32'hAAAA_5555, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write to Timer Range (0x7F08)", test_num);
            IRQ = 0;
            PrAddr = 32'h0000_7F08;
            PrWD = 32'hCAFE_BABE;
            rd1 = 32'h0;
            wen = 1;

            #1;


            check_outputs(6'b000000, 32'h0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Read from Input Device Range (0x7F10)", test_num);
            IRQ = 0;
            PrAddr = 32'h0000_7F10;
            PrWD = 32'h0;
            rd1 = 32'h1111_1111;
            rd2 = 32'h2222_2222;
            rd3 = 32'h3333_3333;
            wen = 0;

            #1;


            check_outputs(6'b000000, 32'h2222_2222, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Read from Output Device Range (0x7F14)", test_num);
            IRQ = 0;
            PrAddr = 32'h0000_7F14;
            PrWD = 32'h0;
            rd1 = 32'h1111_1111;
            rd2 = 32'h2222_2222;
            rd3 = 32'h3333_3333;
            wen = 0;

            #1;


            check_outputs(6'b000000, 32'h3333_3333, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Write to Output Device Range (0x7F14)", test_num);
            IRQ = 0;
            PrAddr = 32'h0000_7F14;
            PrWD = 32'h8888_9999;
            wen = 1;

            #1;


            check_outputs(6'b000000, 32'h0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Check Hardware Interrupt Generation", test_num);
            IRQ = 1;
            PrAddr = 32'h0;
            wen = 0;


            #1;



            check_outputs(6'b000100, 32'h0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Accessing Invalid Address", test_num);
            IRQ = 0;
            PrAddr = 32'h0000_1000;
            PrWD = 32'hFFFF_FFFF;
            wen = 1;

            #1;


            check_outputs(6'b000000, 32'h0, 0, 0);
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
        input [5:0] expected_HWInt;
        input [31:0] expected_PrRD;
        input expected_outwe;
        input expected_twe;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_HWInt === (expected_HWInt ^ HWInt ^ expected_HWInt) &&
                expected_PrRD === (expected_PrRD ^ PrRD ^ expected_PrRD) &&
                expected_outwe === (expected_outwe ^ outwe ^ expected_outwe) &&
                expected_twe === (expected_twe ^ twe ^ expected_twe)) begin
                $display("PASS");
                $display("  Outputs: HWInt=%h, PrRD=%h, outwe=%b, twe=%b",
                         HWInt, PrRD, outwe, twe);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HWInt=%h, PrRD=%h, outwe=%b, twe=%b",
                         expected_HWInt, expected_PrRD, expected_outwe, expected_twe);
                $display("  Got:      HWInt=%h, PrRD=%h, outwe=%b, twe=%b",
                         HWInt, PrRD, outwe, twe);
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
