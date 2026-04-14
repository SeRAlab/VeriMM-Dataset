`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Data;
    reg LoadSigned;
    reg [3:0] MemRead;
    wire [31:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data(Data),
        .LoadSigned(LoadSigned),
        .MemRead(MemRead),
        .Out(Out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Byte 0, Unsigned", test_num);
            Data = 32'hAABBCC88;
            LoadSigned = 0;
            MemRead = 4'b0001;
            #1;

            check_outputs(32'h00000088);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Byte 0, Signed (Negative)", test_num);
            Data = 32'hAABBCC88;
            LoadSigned = 1;
            MemRead = 4'b0001;
            #1;

            check_outputs(32'hFFFFFF88);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Byte 1, Unsigned", test_num);
            Data = 32'hAABBCC88;
            LoadSigned = 0;
            MemRead = 4'b0010;
            #1;

            check_outputs(32'h000000CC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Byte 1, Signed (Negative)", test_num);
            Data = 32'hAABBCC88;
            LoadSigned = 1;
            MemRead = 4'b0010;
            #1;

            check_outputs(32'hFFFFFFCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Byte 2, Signed (Positive)", test_num);
            Data = 32'hAA33CC88;
            LoadSigned = 1;
            MemRead = 4'b0100;
            #1;

            check_outputs(32'h00000033);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Byte 3, Signed (Negative)", test_num);
            Data = 32'hAABBCC88;
            LoadSigned = 1;
            MemRead = 4'b1000;
            #1;

            check_outputs(32'hFFFFFFAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Half-word 0, Unsigned", test_num);
            Data = 32'h12348678;
            LoadSigned = 0;
            MemRead = 4'b0011;
            #1;

            check_outputs(32'h00008678);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Half-word 0, Signed (Negative)", test_num);
            Data = 32'h12348678;
            LoadSigned = 1;
            MemRead = 4'b0011;
            #1;

            check_outputs(32'hFFFF8678);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Half-word 1, Signed (Positive)", test_num);
            Data = 32'h12348678;
            LoadSigned = 1;
            MemRead = 4'b1100;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Word Load", test_num);
            Data = 32'hDEADBEEF;
            LoadSigned = 0;
            MemRead = 4'b1111;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed Full Word Load", test_num);
            Data = 32'h80000000;
            LoadSigned = 1;
            MemRead = 4'b1111;
            #1;

            check_outputs(32'h80000000);
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
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input [31:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
