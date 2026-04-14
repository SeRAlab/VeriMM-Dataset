`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] mem_alu_r;
    reg mem_c_rfw;
    reg [1:0] mem_c_wbsource;
    reg [31:0] mem_dmem_in;
    reg [31:0] mem_jalra;
    reg [4:0] mem_rf_waddr;
    wire [4:0] rf_waddr;
    wire rfw;
    wire [31:0] wdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mem_alu_r(mem_alu_r),
        .mem_c_rfw(mem_c_rfw),
        .mem_c_wbsource(mem_c_wbsource),
        .mem_dmem_in(mem_dmem_in),
        .mem_jalra(mem_jalra),
        .mem_rf_waddr(mem_rf_waddr),
        .rf_waddr(rf_waddr),
        .rfw(rfw),
        .wdata(wdata)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select ALU Result", test_num);
            mem_c_rfw = 1'b1;
            mem_c_wbsource = 2'b00;
            mem_alu_r = 32'hDEADBEEF;
            mem_dmem_in = 32'h0;
            mem_jalra = 32'h0;
            mem_rf_waddr = 5'd15;

            #1;


            check_outputs(5'd15, 1'b1, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select Data Memory", test_num);
            mem_c_rfw = 1'b1;
            mem_c_wbsource = 2'b01;
            mem_alu_r = 32'hAAAA_AAAA;
            mem_dmem_in = 32'h1234_5678;
            mem_jalra = 32'h0;
            mem_rf_waddr = 5'd31;

            #1;


            check_outputs(5'd31, 1'b1, 32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select JAL/JALR Address", test_num);
            mem_c_rfw = 1'b1;
            mem_c_wbsource = 2'b10;
            mem_alu_r = 32'h0;
            mem_dmem_in = 32'h0;
            mem_jalra = 32'h0040_0004;
            mem_rf_waddr = 5'd1;

            #1;


            check_outputs(5'd1, 1'b1, 32'h0040_0004);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Disable (rfw = 0)", test_num);
            mem_c_rfw = 1'b0;
            mem_c_wbsource = 2'b00;
            mem_alu_r = 32'h5555_5555;
            mem_rf_waddr = 5'd10;


            #1;



            check_outputs(5'd10, 1'b0, 32'h5555_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify RF Write Address Path", test_num);
            mem_c_rfw = 1'b1;
            mem_c_wbsource = 2'b00;
            mem_alu_r = 32'h0;
            mem_rf_waddr = 5'd7;

            #1;


            check_outputs(5'd7, 1'b1, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Data Values", test_num);
            mem_c_rfw = 1'b1;
            mem_c_wbsource = 2'b01;
            mem_dmem_in = 32'hFFFF_FFFF;
            mem_rf_waddr = 5'd0;

            #1;


            check_outputs(5'd0, 1'b1, 32'hFFFF_FFFF);
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
        input [4:0] expected_rf_waddr;
        input expected_rfw;
        input [31:0] expected_wdata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rf_waddr === (expected_rf_waddr ^ rf_waddr ^ expected_rf_waddr) &&
                expected_rfw === (expected_rfw ^ rfw ^ expected_rfw) &&
                expected_wdata === (expected_wdata ^ wdata ^ expected_wdata)) begin
                $display("PASS");
                $display("  Outputs: rf_waddr=%h, rfw=%b, wdata=%h",
                         rf_waddr, rfw, wdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rf_waddr=%h, rfw=%b, wdata=%h",
                         expected_rf_waddr, expected_rfw, expected_wdata);
                $display("  Got:      rf_waddr=%h, rfw=%b, wdata=%h",
                         rf_waddr, rfw, wdata);
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
