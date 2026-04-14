`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] rd_mem;
    reg [4:0] rd_wb;
    reg regwrite_mem;
    reg regwrite_wb;
    reg [4:0] rs;
    reg [4:0] rt;
    wire [1:0] forwards;
    wire [1:0] forwardt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rd_mem(rd_mem),
        .rd_wb(rd_wb),
        .regwrite_mem(regwrite_mem),
        .regwrite_wb(regwrite_wb),
        .rs(rs),
        .rt(rt),
        .forwards(forwards),
        .forwardt(forwardt)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No Hazards (Initial state)", test_num);

            regwrite_mem = 0; regwrite_wb = 0;
            rd_mem = 0; rd_wb = 0;
            rs = 1; rt = 2;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: MEM Hazard on rs", test_num);
            regwrite_mem = 1; regwrite_wb = 0;
            rd_mem = 5; rd_wb = 0;
            rs = 5; rt = 2;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: MEM Hazard on rt", test_num);
            regwrite_mem = 1; regwrite_wb = 0;
            rd_mem = 5; rd_wb = 0;
            rs = 1; rt = 5;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: WB Hazard on rs", test_num);
            regwrite_mem = 0; regwrite_wb = 1;
            rd_mem = 0; rd_wb = 10;
            rs = 10; rt = 2;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: WB Hazard on rt", test_num);
            regwrite_mem = 0; regwrite_wb = 1;
            rd_mem = 0; rd_wb = 10;
            rs = 1; rt = 10;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Simultaneous hazards (MEM rs, WB rt)", test_num);
            regwrite_mem = 1; regwrite_wb = 1;
            rd_mem = 5; rd_wb = 10;
            rs = 5; rt = 10;
            #1;

            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Priority Hazard (Double Hazard on rs)", test_num);

            regwrite_mem = 1; regwrite_wb = 1;
            rd_mem = 5; rd_wb = 5;
            rs = 5; rt = 2;
            #1;

            check_outputs(2'b10, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Priority Hazard (Double Hazard on rt)", test_num);

            regwrite_mem = 1; regwrite_wb = 1;
            rd_mem = 8; rd_wb = 8;
            rs = 1; rt = 8;
            #1;

            check_outputs(2'b00, 2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Register $0 Hazard (Should not forward)", test_num);

            regwrite_mem = 1; regwrite_wb = 1;
            rd_mem = 0; rd_wb = 0;
            rs = 0; rt = 0;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: RegWrite signals low", test_num);

            regwrite_mem = 0; regwrite_wb = 0;
            rd_mem = 5; rd_wb = 10;
            rs = 5; rt = 10;
            #1;

            check_outputs(2'b00, 2'b00);
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
        input [1:0] expected_forwards;
        input [1:0] expected_forwardt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forwards === (expected_forwards ^ forwards ^ expected_forwards) &&
                expected_forwardt === (expected_forwardt ^ forwardt ^ expected_forwardt)) begin
                $display("PASS");
                $display("  Outputs: forwards=%h, forwardt=%h",
                         forwards, forwardt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forwards=%h, forwardt=%h",
                         expected_forwards, expected_forwardt);
                $display("  Got:      forwards=%h, forwardt=%h",
                         forwards, forwardt);
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
