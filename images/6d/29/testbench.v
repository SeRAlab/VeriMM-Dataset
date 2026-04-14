`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Mtoreg;
    reg [31:0] resc3;
    reg [31:0] roadc5;
    wire [31:0] sWritedata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Mtoreg(Mtoreg),
        .resc3(resc3),
        .roadc5(roadc5),
        .sWritedata(sWritedata)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select resc3 (Mtoreg = 0)", test_num);
            resc3 = 32'hAAAA_BBBB;
            roadc5 = 32'h1111_2222;
            Mtoreg = 0;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select roadc5 (Mtoreg = 1)", test_num);
            resc3 = 32'hAAAA_BBBB;
            roadc5 = 32'h1111_2222;
            Mtoreg = 1;
            #1;

            check_outputs(32'h1111_2222);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros on resc3", test_num);
            resc3 = 32'h0000_0000;
            roadc5 = 32'hFFFF_FFFF;
            Mtoreg = 0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones on roadc5", test_num);
            resc3 = 32'h0000_0000;
            roadc5 = 32'hFFFF_FFFF;
            Mtoreg = 1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits pattern (0x5/0xA)", test_num);
            resc3 = 32'h5555_5555;
            roadc5 = 32'hAAAA_AAAA;
            Mtoreg = 0;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Change control while data is stable", test_num);
            resc3 = 32'h1234_5678;
            roadc5 = 32'h8765_4321;
            Mtoreg = 1;
            #5;
            Mtoreg = 0;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Extreme values (0xFFFFFFFF select)", test_num);
            resc3 = 32'hFFFF_FFFF;
            roadc5 = 32'h0000_0000;
            Mtoreg = 0;
            #1;

            check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_sWritedata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sWritedata === (expected_sWritedata ^ sWritedata ^ expected_sWritedata)) begin
                $display("PASS");
                $display("  Outputs: sWritedata=%h",
                         sWritedata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sWritedata=%h",
                         expected_sWritedata);
                $display("  Got:      sWritedata=%h",
                         sWritedata);
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
