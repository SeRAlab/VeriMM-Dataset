`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] aluResult_MEM_WB;
    reg jal_MEM_WB;
    reg [15:0] memData_MEM_WB;
    reg memRe_MEM_WB;
    reg [3:0] p1Addr;
    reg [15:0] pcNext_MEM_WB;
    reg [3:0] regAddr_MEM_WB;
    reg regWe_MEM_WB;
    reg [15:0] wrtData;
    wire [15:0] forwardWrtData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluResult_MEM_WB(aluResult_MEM_WB),
        .jal_MEM_WB(jal_MEM_WB),
        .memData_MEM_WB(memData_MEM_WB),
        .memRe_MEM_WB(memRe_MEM_WB),
        .p1Addr(p1Addr),
        .pcNext_MEM_WB(pcNext_MEM_WB),
        .regAddr_MEM_WB(regAddr_MEM_WB),
        .regWe_MEM_WB(regWe_MEM_WB),
        .wrtData(wrtData),
        .forwardWrtData(forwardWrtData)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No forwarding - Address mismatch", test_num);
            wrtData = 16'hAAAA;
            p1Addr = 4'h1;
            regAddr_MEM_WB = 4'h2;
            regWe_MEM_WB = 1'b1;
            aluResult_MEM_WB = 16'h1111;
            jal_MEM_WB = 1'b0;
            memRe_MEM_WB = 1'b0;
            pcNext_MEM_WB = 16'h0000;
            memData_MEM_WB = 16'h0000;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No forwarding - Write Enable low", test_num);
            wrtData = 16'hBBBB;
            p1Addr = 4'h5;
            regAddr_MEM_WB = 4'h5;
            regWe_MEM_WB = 1'b0;
            aluResult_MEM_WB = 16'h2222;
            jal_MEM_WB = 1'b0;
            memRe_MEM_WB = 1'b0;
            #1;

            check_outputs(16'hBBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Forward ALU Result", test_num);
            wrtData = 16'h0000;
            p1Addr = 4'hA;
            regAddr_MEM_WB = 4'hA;
            regWe_MEM_WB = 1'b1;
            aluResult_MEM_WB = 16'h1234;
            jal_MEM_WB = 1'b0;
            memRe_MEM_WB = 1'b0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Forward Memory Data", test_num);
            wrtData = 16'h0000;
            p1Addr = 4'h3;
            regAddr_MEM_WB = 4'h3;
            regWe_MEM_WB = 1'b1;
            aluResult_MEM_WB = 16'h9999;
            jal_MEM_WB = 1'b0;
            memRe_MEM_WB = 1'b1;
            memData_MEM_WB = 16'hABCD;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Forward PC Next (JAL)", test_num);
            wrtData = 16'h0000;
            p1Addr = 4'h7;
            regAddr_MEM_WB = 4'h7;
            regWe_MEM_WB = 1'b1;
            aluResult_MEM_WB = 16'h0000;
            jal_MEM_WB = 1'b1;
            pcNext_MEM_WB = 16'h8008;
            memRe_MEM_WB = 1'b0;
            #1;

            check_outputs(16'h8008);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: JAL Priority Check", test_num);
            wrtData = 16'h0000;
            p1Addr = 4'hF;
            regAddr_MEM_WB = 4'hF;
            regWe_MEM_WB = 1'b1;
            aluResult_MEM_WB = 16'h1111;
            memData_MEM_WB = 16'h2222;
            pcNext_MEM_WB = 16'h3333;
            jal_MEM_WB = 1'b1;
            memRe_MEM_WB = 1'b1;
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Memory Read Priority Check", test_num);
            wrtData = 16'h0000;
            p1Addr = 4'hE;
            regAddr_MEM_WB = 4'hE;
            regWe_MEM_WB = 1'b1;
            aluResult_MEM_WB = 16'h4444;
            memData_MEM_WB = 16'h5555;
            jal_MEM_WB = 1'b0;
            memRe_MEM_WB = 1'b1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Register 0 Forwarding", test_num);
            wrtData = 16'h7777;
            p1Addr = 4'h0;
            regAddr_MEM_WB = 4'h0;
            regWe_MEM_WB = 1'b1;
            aluResult_MEM_WB = 16'h0000;
            jal_MEM_WB = 1'b0;
            memRe_MEM_WB = 1'b0;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_forwardWrtData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwardWrtData === (expected_forwardWrtData ^ forwardWrtData ^ expected_forwardWrtData)) begin
                $display("PASS");
                $display("  Outputs: forwardWrtData=%h",
                         forwardWrtData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwardWrtData=%h",
                         expected_forwardWrtData);
                $display("  Got:      forwardWrtData=%h",
                         forwardWrtData);
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
