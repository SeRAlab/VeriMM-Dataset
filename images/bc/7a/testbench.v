`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] EX_MEM_VALUE;
    reg [31:0] MEM_WB_VALUE;
    reg [31:0] RS_VALUE;
    reg [1:0] forward_control;
    wire [31:0] VALUE_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EX_MEM_VALUE(EX_MEM_VALUE),
        .MEM_WB_VALUE(MEM_WB_VALUE),
        .RS_VALUE(RS_VALUE),
        .forward_control(forward_control),
        .VALUE_OUT(VALUE_OUT)
    );
    task testcase001;

        begin
            test_num = 1;
            RS_VALUE = 32'h1234_5678;
            MEM_WB_VALUE = 32'hDEAD_BEEF;
            EX_MEM_VALUE = 32'hCAFE_BABE;
            forward_control = 2'b00;
            $display("Test %0d: Select RS_VALUE (forward_control=00)", test_num);
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            RS_VALUE = 32'h1234_5678;
            MEM_WB_VALUE = 32'hDEAD_BEEF;
            EX_MEM_VALUE = 32'hCAFE_BABE;
            forward_control = 2'b01;
            $display("Test %0d: Select MEM_WB_VALUE (forward_control=01)", test_num);
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            RS_VALUE = 32'h1234_5678;
            MEM_WB_VALUE = 32'hDEAD_BEEF;
            EX_MEM_VALUE = 32'hCAFE_BABE;
            forward_control = 2'b10;
            $display("Test %0d: Select EX_MEM_VALUE (forward_control=10)", test_num);
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            RS_VALUE = 32'h1111_1111;
            MEM_WB_VALUE = 32'h2222_2222;
            EX_MEM_VALUE = 32'h3333_3333;
            forward_control = 2'b11;
            $display("Test %0d: Invalid forward_control (forward_control=11)", test_num);
            #1;

            check_outputs(32'bx);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            RS_VALUE = 32'h0000_0000;
            MEM_WB_VALUE = 32'hFFFF_FFFF;
            EX_MEM_VALUE = 32'hAAAA_AAAA;
            forward_control = 2'b00;
            $display("Test %0d: Zero RS_VALUE selection", test_num);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            RS_VALUE = 32'h0000_0000;
            MEM_WB_VALUE = 32'hFFFF_FFFF;
            EX_MEM_VALUE = 32'hAAAA_AAAA;
            forward_control = 2'b01;
            $display("Test %0d: All-ones MEM_WB_VALUE selection", test_num);
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            RS_VALUE = 32'h5555_5555;
            MEM_WB_VALUE = 32'h0000_0000;
            EX_MEM_VALUE = 32'hAAAA_AAAA;
            forward_control = 2'b10;
            $display("Test %0d: Alternating bit EX_MEM_VALUE selection", test_num);
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            RS_VALUE = 32'hAABB_CCDD;
            MEM_WB_VALUE = 32'h1122_3344;
            EX_MEM_VALUE = 32'h5566_7788;


            forward_control = 2'b10;
            #5;
            forward_control = 2'b00;
            $display("Test %0d: Dynamic control switch to RS_VALUE", test_num);
            #1;

            check_outputs(32'hAABB_CCDD);
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
        input [31:0] expected_VALUE_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_VALUE_OUT === (expected_VALUE_OUT ^ VALUE_OUT ^ expected_VALUE_OUT)) begin
                $display("PASS");
                $display("  Outputs: VALUE_OUT=%h",
                         VALUE_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VALUE_OUT=%h",
                         expected_VALUE_OUT);
                $display("  Got:      VALUE_OUT=%h",
                         VALUE_OUT);
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
